-- Factory DB — Lesson 14 Verification Script
-- Use this script to check if corrections are needed or have been applied
-- Safe to run anytime (READ-ONLY queries)

-- ============================================================================
-- LESSON 14 IDENTIFICATION
-- ============================================================================

SELECT '=== LESSON 14 IDENTIFICATION ===' AS report_section;

-- Find lesson_ref_id for lesson 14
SELECT 
  lr.lesson_ref_id,
  lr.course_id,
  lr.lesson_id,
  lr.position,
  lr.lesson_group,
  lr.slug,
  lr.title,
  lr.status,
  lr.visibility
FROM lesson_refs lr
WHERE lr.lesson_id = 14 AND lr.course_id = 3;

-- Store lesson_ref_id for subsequent queries
SET @ref_id := (SELECT lesson_ref_id FROM lesson_refs WHERE lesson_id=14 AND course_id=3 LIMIT 1);

SELECT CONCAT('Using lesson_ref_id = ', COALESCE(@ref_id, 'NOT FOUND')) AS info;

-- ============================================================================
-- LESSON 14 STATUS CHECK
-- ============================================================================

SELECT '=== LESSON 14 STATUS REPORT ===' AS report_section;

-- Basic counts
SELECT 
  'Basic Counts' AS metric_type,
  (SELECT COUNT(*) FROM chips WHERE lesson_ref_id=@ref_id) AS chips,
  (SELECT COUNT(*) FROM examples WHERE lesson_ref_id=@ref_id) AS examples,
  (SELECT COUNT(*) FROM lesson_atoms WHERE lesson_ref_id=@ref_id) AS lesson_atoms,
  (SELECT COUNT(*) FROM lesson_rules WHERE lesson_ref_id=@ref_id) AS lesson_rules,
  (SELECT COUNT(*) FROM example_atoms ea JOIN examples e ON e.example_id=ea.example_id WHERE e.lesson_ref_id=@ref_id) AS example_atoms;

-- ============================================================================
-- PROBLEM DETECTION
-- ============================================================================

SELECT '=== PROBLEM DETECTION ===' AS report_section;

-- Problem 1: Examples without form role
SELECT 
  'Examples without FORM' AS problem_type,
  COUNT(*) AS count,
  CASE 
    WHEN COUNT(*) = 0 THEN '✅ FIXED'
    WHEN COUNT(*) > 0 THEN '❌ NEEDS FIX'
  END AS status
FROM examples e
LEFT JOIN example_atoms ea
  ON ea.example_id = e.example_id
  AND ea.example_atom_role_id = (SELECT example_atom_role_id FROM example_atom_roles WHERE code='form' LIMIT 1)
WHERE e.lesson_ref_id = @ref_id AND ea.example_id IS NULL;

-- Problem 2: Examples with multiple forms
SELECT 
  'Examples with >1 FORM' AS problem_type,
  COUNT(*) AS count,
  CASE 
    WHEN COUNT(*) = 0 THEN '✅ FIXED'
    WHEN COUNT(*) > 0 THEN '❌ NEEDS FIX'
  END AS status
FROM (
  SELECT ea.example_id
  FROM example_atoms ea
  JOIN examples e ON e.example_id = ea.example_id
  WHERE e.lesson_ref_id=@ref_id
    AND ea.example_atom_role_id = (SELECT example_atom_role_id FROM example_atom_roles WHERE code='form' LIMIT 1)
  GROUP BY ea.example_id
  HAVING COUNT(*) > 1
) x;

-- Problem 3: French explanatory text (potential candidates for deletion)
SELECT 
  'French explanatory text' AS problem_type,
  COUNT(*) AS count,
  CASE 
    WHEN COUNT(*) = 0 THEN '✅ NONE FOUND'
    WHEN COUNT(*) > 0 THEN '⚠️ REVIEW NEEDED'
  END AS status
FROM examples
WHERE lesson_ref_id = @ref_id 
  AND (kg_text IS NULL OR kg_text = '' OR kg_text LIKE '%se conjugue%' OR kg_text LIKE '%français%');

-- ============================================================================
-- DETAILED LIST OF PROBLEMS (if any)
-- ============================================================================

SELECT '=== DETAILED PROBLEMS ===' AS report_section;

-- List all examples without form (if any)
SELECT 
  'MISSING FORMS' AS detail_type,
  e.example_id, 
  e.kg_text, 
  SUBSTRING_INDEX(TRIM(e.kg_text), ' ', -1) AS expected_form,
  e.fr_text,
  e.notes_md
FROM examples e
LEFT JOIN example_atoms ea
  ON ea.example_id = e.example_id
  AND ea.example_atom_role_id = (SELECT example_atom_role_id FROM example_atom_roles WHERE code='form' LIMIT 1)
WHERE e.lesson_ref_id = @ref_id 
  AND ea.example_id IS NULL
ORDER BY e.example_id;

-- List examples with multiple forms (if any)
SELECT 
  'MULTIPLE FORMS' AS detail_type,
  e.example_id,
  e.kg_text,
  COUNT(*) AS nb_forms,
  GROUP_CONCAT(a.normalized_form ORDER BY a.normalized_form SEPARATOR ', ') AS forms_found
FROM example_atoms ea
JOIN examples e ON e.example_id = ea.example_id
JOIN atoms a ON a.atom_id = ea.atom_id
WHERE e.lesson_ref_id = @ref_id
  AND ea.example_atom_role_id = (SELECT example_atom_role_id FROM example_atom_roles WHERE code='form' LIMIT 1)
GROUP BY e.example_id, e.kg_text
HAVING COUNT(*) > 1
ORDER BY e.example_id;

-- List potential French explanatory text
SELECT 
  'FRENCH TEXT' AS detail_type,
  e.example_id,
  e.kg_text,
  e.fr_text,
  e.notes_md
FROM examples e
WHERE e.lesson_ref_id = @ref_id
  AND (e.kg_text IS NULL OR e.kg_text = '' OR e.kg_text LIKE '%se conjugue%' OR e.kg_text LIKE '%français%')
ORDER BY e.example_id;

-- ============================================================================
-- EXAMPLE ATOMS ROLE DISTRIBUTION
-- ============================================================================

SELECT '=== EXAMPLE ATOMS ROLE DISTRIBUTION ===' AS report_section;

SELECT 
  ear.code AS role_code,
  ear.name AS role_name,
  COUNT(*) AS count
FROM example_atoms ea
JOIN examples e ON e.example_id = ea.example_id
JOIN example_atom_roles ear ON ear.example_atom_role_id = ea.example_atom_role_id
WHERE e.lesson_ref_id = @ref_id
GROUP BY ear.code, ear.name
ORDER BY COUNT(*) DESC;

-- ============================================================================
-- SUMMARY METRICS
-- ============================================================================

SELECT '=== SUMMARY METRICS ===' AS report_section;

SELECT
  'Summary' AS section,
  (SELECT COUNT(*) FROM examples WHERE lesson_ref_id=@ref_id) AS total_examples,
  (SELECT COUNT(*) FROM examples e 
   LEFT JOIN example_atoms ea ON ea.example_id=e.example_id 
     AND ea.example_atom_role_id=(SELECT example_atom_role_id FROM example_atom_roles WHERE code='form' LIMIT 1)
   WHERE e.lesson_ref_id=@ref_id AND ea.example_id IS NULL) AS examples_without_form,
  (SELECT COUNT(*) FROM 
   (SELECT ea.example_id FROM example_atoms ea 
    JOIN examples e ON e.example_id=ea.example_id 
    WHERE e.lesson_ref_id=@ref_id 
      AND ea.example_atom_role_id=(SELECT example_atom_role_id FROM example_atom_roles WHERE code='form' LIMIT 1)
    GROUP BY ea.example_id HAVING COUNT(*)>1) x) AS examples_with_multiple_forms,
  (SELECT COUNT(*) FROM examples WHERE lesson_ref_id=@ref_id 
   AND (kg_text IS NULL OR kg_text='' OR kg_text LIKE '%se conjugue%')) AS potential_french_text;

-- ============================================================================
-- COMPLETION MESSAGE
-- ============================================================================

SELECT '=== VERIFICATION COMPLETE ===' AS report_section;
SELECT 'Review the results above to determine if corrections are needed.' AS message;
SELECT 'If problems are detected, run factory_lesson14_fix_forms.sql to apply corrections.' AS next_step;
