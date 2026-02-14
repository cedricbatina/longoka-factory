-- Factory DB — Lesson 13 Verification Script
-- Use this script to check if corrections are needed or have been applied
-- Safe to run anytime (READ-ONLY queries)

-- ============================================================================
-- LESSON 13 STATUS CHECK
-- ============================================================================

SELECT '=== LESSON 13 STATUS REPORT ===' AS report_section;

-- Basic counts
SELECT 
  'Basic Counts' AS metric_type,
  (SELECT COUNT(*) FROM chips WHERE lesson_ref_id=6) AS chips,
  (SELECT COUNT(*) FROM examples WHERE lesson_ref_id=6) AS examples,
  (SELECT COUNT(*) FROM lesson_atoms WHERE lesson_ref_id=6) AS lesson_atoms,
  (SELECT COUNT(*) FROM lesson_rules WHERE lesson_ref_id=6) AS lesson_rules,
  (SELECT COUNT(*) FROM example_atoms ea JOIN examples e ON e.example_id=ea.example_id WHERE e.lesson_ref_id=6) AS example_atoms;

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
WHERE e.lesson_ref_id = 6 AND ea.example_id IS NULL;

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
  WHERE e.lesson_ref_id=6
    AND ea.example_atom_role_id = (SELECT example_atom_role_id FROM example_atom_roles WHERE code='form' LIMIT 1)
  GROUP BY ea.example_id
  HAVING COUNT(*) > 1
) x;

-- Problem 3: French explanatory text (should be deleted)
SELECT 
  'French explanatory text' AS problem_type,
  COUNT(*) AS count,
  CASE 
    WHEN COUNT(*) = 0 THEN '✅ FIXED (deleted)'
    WHEN COUNT(*) = 2 THEN '❌ NEEDS FIX (should delete)'
  END AS status
FROM examples
WHERE lesson_ref_id = 6 
  AND example_id IN (366, 392);

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
  e.notes_md
FROM examples e
LEFT JOIN example_atoms ea
  ON ea.example_id = e.example_id
  AND ea.example_atom_role_id = (SELECT example_atom_role_id FROM example_atom_roles WHERE code='form' LIMIT 1)
WHERE e.lesson_ref_id = 6 
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
WHERE e.lesson_ref_id=6
  AND ea.example_atom_role_id = (SELECT example_atom_role_id FROM example_atom_roles WHERE code='form' LIMIT 1)
GROUP BY e.example_id, e.kg_text
HAVING COUNT(*) > 1
ORDER BY nb_forms DESC, e.example_id;

-- List French explanatory text (if still present)
SELECT 
  'FRENCH TEXT' AS detail_type,
  example_id,
  kg_text,
  'Should be deleted' AS action_needed
FROM examples
WHERE lesson_ref_id = 6 
  AND example_id IN (366, 392);

-- ============================================================================
-- ROLE DISTRIBUTION
-- ============================================================================

SELECT '=== EXAMPLE_ATOMS ROLE DISTRIBUTION ===' AS report_section;

SELECT 
  COALESCE(r.code, 'NULL') AS role_code,
  COUNT(*) AS count
FROM examples e
JOIN example_atoms ea ON ea.example_id=e.example_id
LEFT JOIN example_atom_roles r ON r.example_atom_role_id=ea.example_atom_role_id
WHERE e.lesson_ref_id=6
GROUP BY r.code
ORDER BY count DESC;

-- Expected distribution after fix:
-- form: 57 (was 44, +14 new, -1 converted to variant)
-- auxiliary: 43
-- subject_prefix: 42
-- suffix: 24
-- particle: 13
-- variant_form: 8 (was 7, +1 from form)

-- ============================================================================
-- EXAMPLE 348 SPECIFIC CHECK
-- ============================================================================

SELECT '=== EXAMPLE 348 CHECK ===' AS report_section;

SELECT 
  e.example_id,
  e.kg_text,
  r.code AS role,
  a.normalized_form,
  CASE 
    WHEN r.code = 'form' AND a.normalized_form = 'uena' THEN '✅ Correct (main form)'
    WHEN r.code = 'variant_form' AND a.normalized_form != 'uena' THEN '✅ Correct (variant)'
    WHEN r.code = 'form' AND a.normalized_form != 'uena' THEN '❌ Should be variant_form'
    ELSE '⚠️ Check manually'
  END AS validation_status
FROM examples e
JOIN example_atoms ea ON ea.example_id = e.example_id
JOIN atoms a ON a.atom_id = ea.atom_id
LEFT JOIN example_atom_roles r ON r.example_atom_role_id = ea.example_atom_role_id
WHERE e.example_id = 348
  AND r.code IN ('form', 'variant_form')
ORDER BY r.code, a.normalized_form;

-- ============================================================================
-- OVERALL STATUS SUMMARY
-- ============================================================================

SELECT '=== OVERALL STATUS ===' AS report_section;

SELECT 
  CASE 
    WHEN 
      (SELECT COUNT(*) FROM examples e
       LEFT JOIN example_atoms ea ON ea.example_id = e.example_id 
         AND ea.example_atom_role_id = (SELECT example_atom_role_id FROM example_atom_roles WHERE code='form')
       WHERE e.lesson_ref_id = 6 AND ea.example_id IS NULL) = 0
      AND
      (SELECT COUNT(*) FROM (
        SELECT ea.example_id FROM example_atoms ea
        JOIN examples e ON e.example_id = ea.example_id
        WHERE e.lesson_ref_id=6 AND ea.example_atom_role_id = (SELECT example_atom_role_id FROM example_atom_roles WHERE code='form')
        GROUP BY ea.example_id HAVING COUNT(*) > 1
      ) x) = 0
      AND
      (SELECT COUNT(*) FROM examples WHERE lesson_ref_id = 6 AND example_id IN (366, 392)) = 0
    THEN '✅ ALL CORRECTIONS APPLIED SUCCESSFULLY'
    ELSE '❌ CORRECTIONS NEEDED - Run factory_lesson13_fix_forms.sql'
  END AS overall_status;

-- ============================================================================
-- EXPORT READINESS CHECK
-- ============================================================================

SELECT '=== EXPORT READINESS ===' AS report_section;

SELECT 
  CASE 
    WHEN (SELECT COUNT(*) FROM examples e
          LEFT JOIN example_atoms ea ON ea.example_id = e.example_id 
            AND ea.example_atom_role_id = (SELECT example_atom_role_id FROM example_atom_roles WHERE code='form')
          WHERE e.lesson_ref_id = 6 AND ea.example_id IS NULL) = 0
    THEN '✅ Ready to export'
    ELSE '❌ Fix problems before export'
  END AS export_status,
  'la-conjugaison-du-verbe-etre-en-kikongo' AS slug,
  'D:\\works\\lectures\\corrected kikongo course\\La conjugaison\\lesson-13-la-conjugaison-du-verbe-etre' AS output_directory;

-- ============================================================================
-- END OF VERIFICATION SCRIPT
-- ============================================================================
