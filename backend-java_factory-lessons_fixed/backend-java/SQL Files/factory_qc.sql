-- Factory DB (6i695q_factory_db)
-- Dashboard helper views (read-only)
-- MySQL 8.x

-- 1) Overview: one row per lesson_ref with counters
CREATE OR REPLACE VIEW v_lessons_overview AS
SELECT
  lr.lesson_ref_id,
  lr.platform_id,
  lr.course_id,
  lr.lesson_id,
  lr.position,
  lr.lesson_group,
  lr.slug,
  lr.title,
  lr.status,
  lr.visibility,
  COUNT(DISTINCT c.chip_id)     AS nb_chips,
  COUNT(DISTINCT lru.rule_id)   AS nb_rules,
  COUNT(DISTINCT ex.example_id) AS nb_examples,
  COUNT(DISTINCT la.atom_id)    AS nb_atoms
FROM lesson_refs lr
LEFT JOIN chips c         ON c.lesson_ref_id = lr.lesson_ref_id
LEFT JOIN lesson_rules lru ON lru.lesson_ref_id = lr.lesson_ref_id
LEFT JOIN examples ex     ON ex.lesson_ref_id = lr.lesson_ref_id
LEFT JOIN lesson_atoms la ON la.lesson_ref_id = lr.lesson_ref_id
GROUP BY lr.lesson_ref_id;

-- 2) Chips: list chips with type code
CREATE OR REPLACE VIEW v_lesson_chips AS
SELECT
  c.lesson_ref_id,
  c.chip_id,
  ct.code AS chip_type_code,
  c.title,
  c.content_md
FROM chips c
JOIN chip_types ct ON ct.chip_type_id = c.chip_type_id;

-- 3) Rules: list rules linked to lessons with type + importance
CREATE OR REPLACE VIEW v_lesson_rules AS
SELECT
  lr.lesson_ref_id,
  r.rule_id,
  rt.code AS rule_type_code,
  il.code AS importance_code,
  r.title,
  r.statement_md,
  r.pattern_json,
  r.notes_md
FROM lesson_rules lr
JOIN rules r         ON r.rule_id = lr.rule_id
JOIN rule_types rt   ON rt.rule_type_id = r.rule_type_id
LEFT JOIN importance_levels il ON il.importance_id = lr.importance_id;

-- 4) Examples
CREATE OR REPLACE VIEW v_lesson_examples AS
SELECT
  e.lesson_ref_id,
  e.example_id,
  e.kg_text,
  e.fr_text,
  e.en_text,
  e.notes_md
FROM examples e;

-- 5) Atoms linked to lessons (with role + type/subtype codes)
CREATE OR REPLACE VIEW v_lesson_atoms AS
SELECT
  la.lesson_ref_id,
  a.atom_id,
  lar.code AS lesson_role_code,
  t.code   AS atom_type_code,
  st.code  AS atom_subtype_code,
  a.form,
  a.form_raw,
  a.normalized_form,
  a.gloss_fr,
  a.gloss_en,
  a.notes_md
FROM lesson_atoms la
JOIN atoms a             ON a.atom_id = la.atom_id
JOIN lesson_atom_roles lar ON lar.lesson_atom_role_id = la.lesson_atom_role_id
JOIN atom_types t        ON t.atom_type_id = a.atom_type_id
LEFT JOIN atom_subtypes st ON st.atom_subtype_id = a.atom_subtype_id;

-- 6) Relations touching lesson atoms (handy for graph navigation)
CREATE OR REPLACE VIEW v_lesson_atom_relations AS
SELECT
  la.lesson_ref_id,
  ar.from_atom_id,
  ar.to_atom_id,
  rt.code AS relation_type_code,
  ar.notes_md
FROM lesson_atoms la
JOIN atom_relations ar ON ar.from_atom_id = la.atom_id OR ar.to_atom_id = la.atom_id
JOIN relation_types rt ON rt.relation_type_id = ar.relation_type_id;



-- Factory DB sanity checks / QC queries

-- A) Snapshot counts
SELECT COUNT(*) AS nb_lesson_refs FROM lesson_refs;
SELECT COUNT(*) AS nb_chips       FROM chips;
SELECT COUNT(*) AS nb_rules       FROM rules;
SELECT COUNT(*) AS nb_examples    FROM examples;
SELECT COUNT(*) AS nb_atoms       FROM atoms;
SELECT COUNT(*) AS nb_relations   FROM atom_relations;

-- B) Missing decompositions (atoms that *should* have grapheme seq but don't)
-- (Adjust atom_type_code list depending on your conventions)
SELECT a.atom_id, t.code AS atom_type_code, a.normalized_form
FROM atoms a
JOIN atom_types t ON t.atom_type_id=a.atom_type_id
LEFT JOIN atom_grapheme_seq ags ON ags.atom_id=a.atom_id
WHERE t.code IN ('syllable','word','stem','morpheme')
GROUP BY a.atom_id
HAVING COUNT(ags.grapheme_id)=0;

-- C) Incomplete decomposition: seq gaps / duplicates per (atom, orthography)
SELECT ags.atom_id, ags.orthography_id,
       COUNT(*) AS n_rows,
       COUNT(DISTINCT ags.seq) AS n_distinct_seq,
       MIN(ags.seq) AS min_seq,
       MAX(ags.seq) AS max_seq
FROM atom_grapheme_seq ags
GROUP BY ags.atom_id, ags.orthography_id
HAVING n_rows <> n_distinct_seq OR min_seq <> 1 OR max_seq <> n_rows;

-- D) Potential atom duplicates (same normalized_form within same language+type)
-- If you don't have language_code in atoms, drop it from the grouping.
SELECT a.language_code, t.code AS atom_type_code, a.normalized_form, COUNT(*) AS n
FROM atoms a
JOIN atom_types t ON t.atom_type_id=a.atom_type_id
GROUP BY a.language_code, t.code, a.normalized_form
HAVING COUNT(*) > 1;

-- E) Lesson coverage: which atoms are used where
SELECT la.lesson_ref_id, COUNT(*) AS nb_atoms
FROM lesson_atoms la
GROUP BY la.lesson_ref_id
ORDER BY la.lesson_ref_id;
