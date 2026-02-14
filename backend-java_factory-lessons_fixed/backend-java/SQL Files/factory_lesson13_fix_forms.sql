-- Factory DB — Fix Lesson 13 (lesson_ref_id=6) — Missing form roles
-- Course 3, Lesson 13: La conjugaison du verbe être en kikongo
-- Date: 2026-02-14
-- 
-- Context:
-- - 16 examples lack a "form" role
-- - Example 348 has 2 forms instead of 1
-- - Examples 366 and 392 are French explanatory text, not actual examples
--
-- This script:
-- A) Normalizes example_id=348 (keeps 1 form, converts others to variant_form)
-- B) Creates and links missing forms (last word of kg_text)
-- C) Deletes examples 366 and 392 (French explanatory text)

-- ============================================================================
-- PRE-FLIGHT CHECKS (Audit queries - run these first to verify the problem)
-- ============================================================================

-- Count examples without form role
SELECT 'Examples without form' AS check_type, COUNT(*) AS count
FROM examples e
LEFT JOIN example_atoms ea
  ON ea.example_id = e.example_id
  AND ea.example_atom_role_id = (SELECT example_atom_role_id FROM example_atom_roles WHERE code='form' LIMIT 1)
WHERE e.lesson_ref_id = 6 AND ea.example_id IS NULL;

-- List examples with multiple forms
SELECT 'Examples with >1 form' AS check_type, ea.example_id, COUNT(*) AS nb_form
FROM example_atoms ea
JOIN examples e ON e.example_id = ea.example_id
WHERE e.lesson_ref_id=6
  AND ea.example_atom_role_id = (SELECT example_atom_role_id FROM example_atom_roles WHERE code='form' LIMIT 1)
GROUP BY ea.example_id
HAVING COUNT(*) > 1;

-- List all examples without form
SELECT e.example_id, e.kg_text, e.notes_md
FROM examples e
LEFT JOIN example_atoms ea
  ON ea.example_id = e.example_id
  AND ea.example_atom_role_id = (SELECT example_atom_role_id FROM example_atom_roles WHERE code='form' LIMIT 1)
WHERE e.lesson_ref_id = 6 AND ea.example_id IS NULL
ORDER BY e.example_id;

-- ============================================================================
-- A) NORMALIZE EXAMPLE 348: Keep 1 form, convert others to variant_form
-- ============================================================================

-- Set role IDs
SET @role_form := (SELECT example_atom_role_id FROM example_atom_roles WHERE code='form' LIMIT 1);
SET @role_variant := (SELECT example_atom_role_id FROM example_atom_roles WHERE code='variant_form' LIMIT 1);

-- First, identify which atom is 'uena' (this will be our main form)
SET @main_form_atom_id := (
  SELECT atom_id 
  FROM atoms 
  WHERE language_code='kg' AND normalized_form='uena' 
  LIMIT 1
);

-- Update all form roles for example 348 to variant_form first
UPDATE example_atoms ea
SET ea.example_atom_role_id = @role_variant
WHERE ea.example_id = 348
  AND ea.example_atom_role_id = @role_form;

-- Then set the main form back to 'form' role
UPDATE example_atoms ea
SET ea.example_atom_role_id = @role_form
WHERE ea.example_id = 348
  AND ea.atom_id = @main_form_atom_id;

-- ============================================================================
-- B) CREATE AND LINK MISSING FORMS (last word of kg_text)
-- ============================================================================

SET @type_word := (SELECT atom_type_id FROM atom_types WHERE code='word' LIMIT 1);
SET @role_form := (SELECT example_atom_role_id FROM example_atom_roles WHERE code='form' LIMIT 1);

-- Create missing atoms (last word from kg_text, excluding French text)
INSERT INTO atoms (language_code, atom_type_id, atom_subtype_id, form, normalized_form)
SELECT 'kg', @type_word, NULL, x.form, x.norm
FROM (
  SELECT DISTINCT
    SUBSTRING_INDEX(TRIM(e.kg_text), ' ', -1) AS form,
    LOWER(SUBSTRING_INDEX(TRIM(e.kg_text), ' ', -1)) AS norm
  FROM examples e
  LEFT JOIN example_atoms ea
    ON ea.example_id=e.example_id AND ea.example_atom_role_id=@role_form
  WHERE e.lesson_ref_id=6
    AND ea.example_id IS NULL
    AND e.kg_text NOT LIKE '% se conjugue %'
) x
LEFT JOIN atoms a ON a.language_code='kg' AND a.normalized_form=x.norm
WHERE a.atom_id IS NULL;

-- Link missing forms to examples
INSERT IGNORE INTO example_atoms (example_id, atom_id, example_atom_role_id)
SELECT e.example_id, a.atom_id, @role_form
FROM examples e
LEFT JOIN example_atoms ea
  ON ea.example_id=e.example_id AND ea.example_atom_role_id=@role_form
JOIN atoms a
  ON a.language_code='kg'
 AND a.normalized_form = LOWER(SUBSTRING_INDEX(TRIM(e.kg_text), ' ', -1))
WHERE e.lesson_ref_id=6
  AND ea.example_id IS NULL
  AND e.kg_text NOT LIKE '% se conjugue %';

-- ============================================================================
-- C) HANDLE FRENCH EXPLANATORY TEXT (examples 366 and 392)
-- ============================================================================

-- Option 1: Delete these examples (they are not real examples)
-- Uncomment the following line to delete them:
-- DELETE FROM examples WHERE lesson_ref_id=6 AND example_id IN (366,392);

-- Option 2: Keep them but add a note (commenting this out by default)
-- UPDATE examples 
-- SET notes_md = CONCAT(COALESCE(notes_md, ''), '\n**Note**: Texte explicatif (pas un exemple)')
-- WHERE lesson_ref_id=6 AND example_id IN (366,392);

-- For now, we'll delete them as they don't fit the example structure
DELETE FROM examples WHERE lesson_ref_id=6 AND example_id IN (366,392);

-- ============================================================================
-- POST-FLIGHT VERIFICATION (run these to verify the fix)
-- ============================================================================

-- Should return 0 examples without form (excluding any remaining French text)
SELECT 'Examples still without form' AS check_type, COUNT(*) AS count
FROM examples e
LEFT JOIN example_atoms ea
  ON ea.example_id = e.example_id
  AND ea.example_atom_role_id = (SELECT example_atom_role_id FROM example_atom_roles WHERE code='form' LIMIT 1)
WHERE e.lesson_ref_id = 6 AND ea.example_id IS NULL;

-- Should return 0 examples with multiple forms
SELECT 'Examples still with >1 form' AS check_type, COUNT(*) AS count
FROM (
  SELECT ea.example_id
  FROM example_atoms ea
  JOIN examples e ON e.example_id = ea.example_id
  WHERE e.lesson_ref_id=6
    AND ea.example_atom_role_id = (SELECT example_atom_role_id FROM example_atom_roles WHERE code='form' LIMIT 1)
  GROUP BY ea.example_id
  HAVING COUNT(*) > 1
) x;

-- Show final counts for lesson 13
SELECT 
  'Final counts' AS check_type,
  (SELECT COUNT(*) FROM chips c WHERE c.lesson_ref_id=6) AS chips,
  (SELECT COUNT(*) FROM examples e WHERE e.lesson_ref_id=6) AS examples,
  (SELECT COUNT(*) FROM lesson_atoms la WHERE la.lesson_ref_id=6) AS lesson_atoms,
  (SELECT COUNT(*) FROM lesson_rules lru WHERE lru.lesson_ref_id=6) AS lesson_rules,
  (SELECT COUNT(*) FROM example_atoms ea JOIN examples e ON e.example_id=ea.example_id WHERE e.lesson_ref_id=6) AS example_atoms;

-- ============================================================================
-- NOTES
-- ============================================================================
-- 
-- After running this script:
-- 1. Verify the counts match expectations (57 examples instead of 59)
-- 2. Check that all remaining examples have exactly 1 form
-- 3. Export the lesson using:
--    node .\scripts\export-lesson-to-corrected.mjs --slug la-conjugaison-du-verbe-etre-en-kikongo --db-name 6i695q_longoka --out-dir "D:\works\lectures\corrected kikongo course\La conjugaison\lesson-13-la-conjugaison-du-verbe-etre"
-- 
-- Next lesson to process:
--    slug: les-temps-futurs-du-kikongo-classique
--    export dir: D:\works\lectures\corrected kikongo course\La conjugaison\les-temps-futurs-du-kikongo-classique\
