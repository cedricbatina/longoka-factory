-- =========================================================
-- Factory DB — LessonPack export (Leçon 10 = lesson_ref_id=2)
-- MySQL 8.x
-- =========================================================

SET @lr := 2;

-- ---------------------------------------------------------
-- 1) VUES : SG/PL + vocab + scrabble vocab (strict)
-- ---------------------------------------------------------

CREATE OR REPLACE VIEW v_examples_sg_pl AS
SELECT
  e.example_id,
  e.lesson_ref_id,
  CASE
    WHEN LOCATE(' - ', e.kg_text) > 0
      THEN TRIM(SUBSTRING(e.kg_text, 1, LOCATE(' - ', e.kg_text) - 1))
    ELSE TRIM(e.kg_text)
  END AS kg_sg,
  CASE
    WHEN LOCATE(' - ', e.kg_text) > 0
      THEN TRIM(SUBSTRING(e.kg_text, LOCATE(' - ', e.kg_text) + 3))
    ELSE NULL
  END AS kg_pl,
  e.fr_text,
  e.en_text,
  e.notes_md
FROM examples e;

CREATE OR REPLACE VIEW v_lesson_vocab AS
SELECT
  lesson_ref_id,
  example_id,
  'sg' AS form_role,
  kg_sg AS form,
  fr_text,
  notes_md
FROM v_examples_sg_pl
WHERE kg_sg IS NOT NULL AND kg_sg <> ''

UNION ALL

SELECT
  lesson_ref_id,
  example_id,
  'pl' AS form_role,
  kg_pl AS form,
  fr_text,
  notes_md
FROM v_examples_sg_pl
WHERE kg_pl IS NOT NULL AND kg_pl <> '';

-- Scrabble-ready (strict) :
-- - retire espaces / tirets / apostrophes
-- - exclut locutions (espaces), couples restants (tirets), etc.
-- - exclut les préfixes seuls listés (n, zi, mu, ba, mi, di, ma, ki, bi, bu, lu, tu, ku, fi)
CREATE OR REPLACE VIEW v_lesson_vocab_scrabble AS
SELECT
  v.lesson_ref_id,
  v.example_id,
  v.form_role,
  v.form AS form_raw,
  LOWER(
    REPLACE(
      REPLACE(
        REPLACE(
          REPLACE(v.form, ' ', ''),
        '-', ''),
      '''', ''),
    '’', '')
  ) AS form_clean,
  CHAR_LENGTH(
    LOWER(
      REPLACE(
        REPLACE(
          REPLACE(
            REPLACE(v.form, ' ', ''),
          '-', ''),
        '''', ''),
      '’', '')
    )
  ) AS n_letters,
  v.fr_text
FROM v_lesson_vocab v
WHERE v.form IS NOT NULL
  AND v.form <> ''
  AND v.form NOT LIKE '% %'
  AND v.form NOT LIKE '%-%'
  AND v.form NOT LIKE '%/%'
  AND v.form NOT LIKE '%,%'
  AND LOWER(
        REPLACE(
          REPLACE(
            REPLACE(
              REPLACE(v.form, ' ', ''),
            '-', ''),
          '''', ''),
        '’', '')
      ) NOT IN ('n','zi','mu','ba','mi','di','ma','ki','bi','bu','lu','tu','ku','fi');

-- ---------------------------------------------------------
-- 2) EXPORT JSON : LessonPack (un seul champ JSON)
-- ---------------------------------------------------------
-- Notes :
-- - pas de CTE/WITH
-- - on force l'ordre via sous-requêtes ordonnées avant JSON_ARRAYAGG

SELECT JSON_PRETTY(
  JSON_OBJECT(
    'meta', JSON_OBJECT(
      'exported_at', DATE_FORMAT(NOW(), '%Y-%m-%dT%H:%i:%s'),
      'lesson_ref_id', @lr
    ),

    'lesson_ref', (
      SELECT JSON_OBJECT(
        'lesson_ref_id', lr.lesson_ref_id,
        'platform_id', lr.platform_id,
        'course_id', lr.course_id,
        'lesson_id', lr.lesson_id,
        'position', lr.position,
        'lesson_group', lr.lesson_group,
        'slug', lr.slug,
        'title', lr.title,
        'status', lr.status,
        'visibility', lr.visibility
      )
      FROM lesson_refs lr
      WHERE lr.lesson_ref_id = @lr
      LIMIT 1
    ),

    'source', (
      SELECT JSON_OBJECT(
        'source_db', s.source_db,
        'source_table', s.source_table,
        'source_id', s.source_id,
        'source_note', s.source_note,
        'updated_at', DATE_FORMAT(s.updated_at, '%Y-%m-%dT%H:%i:%s')
      )
      FROM lesson_sources s
      WHERE s.lesson_ref_id = @lr
      LIMIT 1
    ),

    'chips', COALESCE((
      SELECT JSON_ARRAYAGG(j.chip_json)
      FROM (
        SELECT JSON_OBJECT(
          'chip_id', c.chip_id,
          'title', c.title,
          'content_md', c.content_md
        ) AS chip_json
        FROM chips c
        WHERE c.lesson_ref_id = @lr
        ORDER BY c.chip_id
      ) j
    ), JSON_ARRAY()),

    'rules', COALESCE((
      SELECT JSON_ARRAYAGG(j.rule_json)
      FROM (
        SELECT JSON_OBJECT(
          'rule_id', r.rule_id,
          'rule_type_code', r.rule_type_code,
          'importance_code', r.importance_code,
          'title', r.title,
          'statement_md', r.statement_md,
          'pattern_json', r.pattern_json,
          'notes_md', r.notes_md
        ) AS rule_json
        FROM v_lesson_rules r
        WHERE r.lesson_ref_id = @lr
        ORDER BY r.rule_id
      ) j
    ), JSON_ARRAY()),

    'examples', COALESCE((
      SELECT JSON_ARRAYAGG(j.ex_json)
      FROM (
        SELECT JSON_OBJECT(
          'example_id', e.example_id,
          'kg_text', e.kg_text,
          'fr_text', e.fr_text,
          'en_text', e.en_text,
          'notes_md', e.notes_md
        ) AS ex_json
        FROM examples e
        WHERE e.lesson_ref_id = @lr
        ORDER BY e.example_id
      ) j
    ), JSON_ARRAY()),

    'vocab', COALESCE((
      SELECT JSON_ARRAYAGG(j.v_json)
      FROM (
        SELECT JSON_OBJECT(
          'example_id', v.example_id,
          'form_role', v.form_role,
          'form', v.form,
          'fr_text', v.fr_text,
          'notes_md', v.notes_md
        ) AS v_json
        FROM v_lesson_vocab v
        WHERE v.lesson_ref_id = @lr
        ORDER BY v.example_id, v.form_role
      ) j
    ), JSON_ARRAY()),

    'scrabble_vocab', COALESCE((
      SELECT JSON_ARRAYAGG(j.s_json)
      FROM (
        SELECT JSON_OBJECT(
          'example_id', s.example_id,
          'form_role', s.form_role,
          'form_raw', s.form_raw,
          'form_clean', s.form_clean,
          'n_letters', s.n_letters,
          'fr_text', s.fr_text
        ) AS s_json
        FROM v_lesson_vocab_scrabble s
        WHERE s.lesson_ref_id = @lr
        ORDER BY s.n_letters DESC, s.form_clean
      ) j
    ), JSON_ARRAY())
  )
) AS lesson_pack_json;
