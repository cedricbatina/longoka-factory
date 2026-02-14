-- Factory DB — Fix Lesson 14 (Le verbe être dans tous ses états) — Missing form roles
-- Course 3, Lesson 14: Le verbe être dans tous ses états
-- Date: 2026-02-14
-- 
-- Context:
-- This script identifies and fixes issues in Lesson 14 similar to Lesson 13:
-- - Examples lacking a "form" role
-- - Examples with multiple forms (should have exactly 1)
-- - Potential French explanatory text that should be removed
--
-- This script:
-- A) Identifies and normalizes examples with multiple forms (keeps 1 form, converts others to variant_form)
-- B) Creates and links missing forms (last word of kg_text)
-- C) Identifies and optionally deletes French explanatory text

-- ============================================================================
-- LESSON 14 IDENTIFICATION
-- ============================================================================

-- Find lesson_ref_id for lesson 14
SET @ref_id := (SELECT lesson_ref_id FROM lesson_refs WHERE lesson_id=14 AND course_id=3 LIMIT 1);

SELECT CONCAT('Processing lesson_ref_id = ', COALESCE(@ref_id, 'NOT FOUND')) AS info;

-- Verify we found the lesson
SELECT 
  lr.lesson_ref_id,
  lr.course_id,
  lr.lesson_id,
  lr.slug,
  lr.title
FROM lesson_refs lr
WHERE lr.lesson_ref_id = @ref_id;

-- ============================================================================
-- PRE-FLIGHT CHECKS (Audit queries - run these first to verify the problem)
-- ============================================================================

SELECT '=== PRE-FLIGHT CHECKS ===' AS report_section;

-- Count examples without form role
SELECT 'Examples without form' AS check_type, COUNT(*) AS count
FROM examples e
LEFT JOIN example_atoms ea
  ON ea.example_id = e.example_id
  AND ea.example_atom_role_id = (SELECT example_atom_role_id FROM example_atom_roles WHERE code='form' LIMIT 1)
WHERE e.lesson_ref_id = @ref_id AND ea.example_id IS NULL;

-- List examples with multiple forms
SELECT 'Examples with >1 form' AS check_type, ea.example_id, COUNT(*) AS nb_form
FROM example_atoms ea
JOIN examples e ON e.example_id = ea.example_id
WHERE e.lesson_ref_id=@ref_id
  AND ea.example_atom_role_id = (SELECT example_atom_role_id FROM example_atom_roles WHERE code='form' LIMIT 1)
GROUP BY ea.example_id
HAVING COUNT(*) > 1;

-- List all examples without form (with their text)
SELECT '=== EXAMPLES WITHOUT FORM ===' AS report_section;
SELECT 
  e.example_id, 
  e.kg_text, 
  SUBSTRING_INDEX(TRIM(e.kg_text), ' ', -1) AS expected_form,
  e.fr_text,
  e.notes_md
FROM examples e
LEFT JOIN example_atoms ea
  ON ea.example_id = e.example_id
  AND ea.example_atom_role_id = (SELECT example_atom_role_id FROM example_atom_roles WHERE code='form' LIMIT 1)
WHERE e.lesson_ref_id = @ref_id AND ea.example_id IS NULL
ORDER BY e.example_id;

-- List potential French explanatory text
SELECT '=== POTENTIAL FRENCH TEXT ===' AS report_section;
SELECT e.example_id, e.kg_text, e.fr_text, e.notes_md
FROM examples e
WHERE e.lesson_ref_id = @ref_id
  AND (e.kg_text IS NULL OR e.kg_text = '' OR e.kg_text LIKE '%se conjugue%' OR e.kg_text LIKE '%français%')
ORDER BY e.example_id;

-- ============================================================================
-- A) NORMALIZE EXAMPLES WITH MULTIPLE FORMS
-- ============================================================================

SELECT '=== NORMALIZING EXAMPLES WITH MULTIPLE FORMS ===' AS report_section;

-- Set role IDs
SET @role_form := (SELECT example_atom_role_id FROM example_atom_roles WHERE code='form' LIMIT 1);
SET @role_variant := (SELECT example_atom_role_id FROM example_atom_roles WHERE code='variant_form' LIMIT 1);

-- For each example with multiple forms, keep the first one as 'form' and convert others to 'variant_form'
-- This query identifies examples with multiple forms
CREATE TEMPORARY TABLE IF NOT EXISTS temp_multi_forms AS
SELECT 
  ea.example_id,
  MIN(ea.example_atom_id) AS keep_form_id
FROM example_atoms ea
JOIN examples e ON e.example_id = ea.example_id
WHERE e.lesson_ref_id = @ref_id
  AND ea.example_atom_role_id = @role_form
GROUP BY ea.example_id
HAVING COUNT(*) > 1;

-- Update all forms to variant_form first
UPDATE example_atoms ea
JOIN temp_multi_forms tmf ON tmf.example_id = ea.example_id
SET ea.example_atom_role_id = @role_variant
WHERE ea.example_atom_role_id = @role_form;

-- Then restore the first form back to 'form' role
UPDATE example_atoms ea
JOIN temp_multi_forms tmf ON tmf.example_atom_id = ea.example_atom_id
SET ea.example_atom_role_id = @role_form;

DROP TEMPORARY TABLE IF EXISTS temp_multi_forms;

SELECT 'Multiple forms normalized' AS status;

-- ============================================================================
-- B) CREATE AND LINK MISSING FORMS (last word of kg_text)
-- ============================================================================

SELECT '=== CREATING MISSING FORMS ===' AS report_section;

SET @type_word := (SELECT atom_type_id FROM atom_types WHERE code='word' LIMIT 1);
SET @role_form := (SELECT example_atom_role_id FROM example_atom_roles WHERE code='form' LIMIT 1);

-- Create missing atoms (last word from kg_text, excluding French text and empty text)
INSERT INTO atoms (language_code, atom_type_id, atom_subtype_id, form, normalized_form)
SELECT 'kg', @type_word, NULL, x.form, x.norm
FROM (
  SELECT DISTINCT
    SUBSTRING_INDEX(TRIM(e.kg_text), ' ', -1) AS form,
    LOWER(SUBSTRING_INDEX(TRIM(e.kg_text), ' ', -1)) AS norm
  FROM examples e
  LEFT JOIN example_atoms ea
    ON ea.example_id=e.example_id AND ea.example_atom_role_id=@role_form
  WHERE e.lesson_ref_id=@ref_id
    AND ea.example_id IS NULL
    AND e.kg_text IS NOT NULL 
    AND e.kg_text != ''
    AND e.kg_text NOT LIKE '% se conjugue %'
    AND e.kg_text NOT LIKE '%français%'
) x
LEFT JOIN atoms a ON a.language_code='kg' AND a.normalized_form=x.norm
WHERE a.atom_id IS NULL;

SELECT ROW_COUNT() AS new_atoms_created;

-- Link missing forms to examples
INSERT IGNORE INTO example_atoms (example_id, atom_id, example_atom_role_id)
SELECT e.example_id, a.atom_id, @role_form
FROM examples e
CROSS JOIN atoms a
LEFT JOIN example_atoms ea_existing
  ON ea_existing.example_id = e.example_id 
  AND ea_existing.example_atom_role_id = @role_form
WHERE e.lesson_ref_id = @ref_id
  AND ea_existing.example_id IS NULL
  AND e.kg_text IS NOT NULL
  AND e.kg_text != ''
  AND e.kg_text NOT LIKE '% se conjugue %'
  AND e.kg_text NOT LIKE '%français%'
  AND a.language_code = 'kg'
  AND a.normalized_form = LOWER(SUBSTRING_INDEX(TRIM(e.kg_text), ' ', -1));

SELECT ROW_COUNT() AS new_form_links_created;

-- ============================================================================
-- C) DELETE FRENCH EXPLANATORY TEXT (OPTIONAL - COMMENTED OUT BY DEFAULT)
-- ============================================================================

SELECT '=== FRENCH EXPLANATORY TEXT DELETION ===' AS report_section;

-- List candidates for deletion
SELECT 'Candidates for deletion:' AS message;
SELECT e.example_id, e.kg_text, e.fr_text
FROM examples e
WHERE e.lesson_ref_id = @ref_id
  AND (e.kg_text IS NULL OR e.kg_text = '' OR e.kg_text LIKE '%se conjugue%' OR e.kg_text LIKE '%français%');

-- UNCOMMENT THE FOLLOWING LINES TO ACTUALLY DELETE FRENCH EXPLANATORY TEXT
-- First delete related example_atoms
-- DELETE ea FROM example_atoms ea
-- JOIN examples e ON e.example_id = ea.example_id
-- WHERE e.lesson_ref_id = @ref_id
--   AND (e.kg_text IS NULL OR e.kg_text = '' OR e.kg_text LIKE '%se conjugue%' OR e.kg_text LIKE '%français%');

-- Then delete the examples themselves
-- DELETE FROM examples
-- WHERE lesson_ref_id = @ref_id
--   AND (kg_text IS NULL OR kg_text = '' OR kg_text LIKE '%se conjugue%' OR kg_text LIKE '%français%');

SELECT 'French text deletion is COMMENTED OUT by default. Review candidates and uncomment if needed.' AS note;

-- ============================================================================
-- POST-CORRECTION VERIFICATION
-- ============================================================================

SELECT '=== POST-CORRECTION VERIFICATION ===' AS report_section;

-- Count examples without form role (should be 0 after corrections)
SELECT 'Examples without form (after fix)' AS check_type, COUNT(*) AS count
FROM examples e
LEFT JOIN example_atoms ea
  ON ea.example_id = e.example_id
  AND ea.example_atom_role_id = (SELECT example_atom_role_id FROM example_atom_roles WHERE code='form' LIMIT 1)
WHERE e.lesson_ref_id = @ref_id 
  AND ea.example_id IS NULL
  AND e.kg_text IS NOT NULL
  AND e.kg_text != ''
  AND e.kg_text NOT LIKE '%se conjugue%';

-- Count examples with multiple forms (should be 0 after corrections)
SELECT 'Examples with >1 form (after fix)' AS check_type, COUNT(*) AS count
FROM (
  SELECT ea.example_id
  FROM example_atoms ea
  JOIN examples e ON e.example_id = ea.example_id
  WHERE e.lesson_ref_id=@ref_id
    AND ea.example_atom_role_id = (SELECT example_atom_role_id FROM example_atom_roles WHERE code='form' LIMIT 1)
  GROUP BY ea.example_id
  HAVING COUNT(*) > 1
) x;

-- Show final counts
SELECT 
  (SELECT COUNT(*) FROM examples WHERE lesson_ref_id=@ref_id) AS total_examples,
  (SELECT COUNT(*) FROM chips WHERE lesson_ref_id=@ref_id) AS total_chips,
  (SELECT COUNT(*) FROM lesson_atoms WHERE lesson_ref_id=@ref_id) AS total_lesson_atoms;

-- ============================================================================
-- COMPLETION MESSAGE
-- ============================================================================

SELECT '=== CORRECTION COMPLETE ===' AS report_section;
SELECT 'Lesson 14 forms have been corrected.' AS message;
SELECT 'Run factory_lesson14_verify.sql again to verify all fixes were applied correctly.' AS next_step;
SELECT 'If French text deletion is needed, uncomment the DELETE statements in section C.' AS note;
