-- Factory DB — Register Leçon 21 (Kikongo)
-- Généré automatiquement (reference only)

-- Déduire platform_id & course_id depuis la leçon seed (lesson_ref_id=1)
SELECT @platform_id := platform_id, @course_id := course_id
FROM lesson_refs WHERE lesson_ref_id=1;

SET @lesson_id := 21;
SET @position := 12; -- ajuster si besoin
SET @lesson_group := 'kikongo';
SET @slug := 'kikongo-lecon-21';
SET @title := 'Leçon 21 — Kikongo';
SET @status := 'draft';
SET @visibility := 'private';

-- Créer la lesson_ref si absente
INSERT INTO lesson_refs (platform_id, course_id, lesson_id, position, lesson_group, slug, title, status, visibility)
SELECT @platform_id, @course_id, @lesson_id, @position, @lesson_group, @slug, @title, @status, @visibility
WHERE NOT EXISTS (
  SELECT 1 FROM lesson_refs WHERE platform_id=@platform_id AND course_id=@course_id AND lesson_id=@lesson_id
);

SET @lr := (SELECT lesson_ref_id FROM lesson_refs WHERE platform_id=@platform_id AND course_id=@course_id AND lesson_id=@lesson_id LIMIT 1);
-- (Optionally add cleanup or further inserts as needed)
