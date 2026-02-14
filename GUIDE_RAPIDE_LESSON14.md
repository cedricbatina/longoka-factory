# 🚀 Guide Rapide — Correction Leçon 14

## ⚡ En 3 étapes (5 minutes)

### 📌 Leçon concernée
- **Titre**: Le verbe être dans tous ses états
- **Slug**: `le-verbe-etre-dans-tous-ses-etats`
- **Course**: 3 (Kikongo)
- **Lesson ID**: 14
- **Groupe**: La conjugaison

---

## Étape 1️⃣ : Backup + Vérification AVANT

```bash
# 1a. Backup complet
mysqldump -u [user] -p 6i695q_factory_db > backup_lesson14_$(date +%Y%m%d_%H%M%S).sql

# 1b. Vérifier l'état AVANT corrections
cd backend-java_factory-lessons_fixed/backend-java/SQL\ Files
mysql -u [user] -p 6i695q_factory_db < factory_lesson14_verify.sql > lesson14_before.txt

# 1c. Consulter les résultats
cat lesson14_before.txt
```

**À noter**:
- Nombre d'exemples sans `form`
- Nombre d'exemples avec >1 `form`
- Textes français éventuels

---

## Étape 2️⃣ : Appliquer les corrections

```bash
# 2a. Exécuter le script de correction
mysql -u [user] -p 6i695q_factory_db < factory_lesson14_fix_forms.sql > lesson14_fix.txt

# 2b. Vérifier les résultats
cat lesson14_fix.txt
```

**Vérifier**:
- ✅ "X new_atoms_created"
- ✅ "X new_form_links_created"
- ✅ "Multiple forms normalized"
- ✅ Aucune erreur MySQL

---

## Étape 3️⃣ : Vérification APRÈS + Export

```bash
# 3a. Vérifier que tout est corrigé
mysql -u [user] -p 6i695q_factory_db < factory_lesson14_verify.sql > lesson14_after.txt

# 3b. Comparer AVANT vs APRÈS
diff lesson14_before.txt lesson14_after.txt

# 3c. Exporter la leçon en JSON
cd ../..
mvn -q -DskipTests package

java -cp target/backend-java-1.0-SNAPSHOT-jar-with-dependencies.jar \
  com.longoka.games.app.FactoryLessonPackJsonExportTool \
  --course 3 --lesson 14 --out ../../lesson-3-14.json

# 3d. Vérifier le JSON
cat ../../lesson-3-14.json | jq '.lesson.title'
```

**Résultat attendu**:
- ✅ Exemples sans `form`: **0**
- ✅ Exemples avec >1 `form`: **0**
- ✅ JSON créé: `lesson-3-14.json`

---

## 📊 Tableau récapitulatif des changements

| Métrique | AVANT | APRÈS | Statut |
|----------|-------|-------|--------|
| Exemples sans `form` | ? | 0 | ✅ FIXÉ |
| Exemples avec >1 `form` | ? | 0 | ✅ FIXÉ |
| Textes français | ? | 0 ou N/A | ⚠️ Voir note |
| Fichier JSON | ❌ | ✅ | ✅ CRÉÉ |

> **Note**: La suppression des textes français est **optionnelle** et **commentée** par défaut dans le script. Décommentez la section C du script `factory_lesson14_fix_forms.sql` si nécessaire.

---

## 🎯 Commandes d'export vers "corrected kikongo course"

Si vous utilisez le workflow classique:

```bash
# Emplacement de destination
DEST_DIR="D:/works/lectures/corrected kikongo course/La conjugaison/le-verbe-etre-dans-tous-ses-etats/"

# Copier le JSON
cp lesson-3-14.json "$DEST_DIR/lesson-3-14.json"

# Ou sous Linux/WSL
DEST_DIR="/mnt/d/works/lectures/corrected kikongo course/La conjugaison/le-verbe-etre-dans-tous-ses-etats/"
cp lesson-3-14.json "$DEST_DIR/"
```

---

## 🔄 En cas de problème

### Rollback complet

```bash
# Restaurer depuis le backup
mysql -u [user] -p 6i695q_factory_db < backup_lesson14_YYYYMMDD_HHMMSS.sql
```

### Rejouer les corrections

Le script est **idempotent** (peut être rejoué sans danger), mais ce n'est **pas recommandé** sans avoir d'abord vérifié l'état actuel.

```bash
# Re-vérifier d'abord
mysql -u [user] -p 6i695q_factory_db < factory_lesson14_verify.sql

# Rejouer si nécessaire
mysql -u [user] -p 6i695q_factory_db < factory_lesson14_fix_forms.sql
```

---

## ✅ Prochaines étapes

Après avoir corrigé la Leçon 14:

1. ✅ **Valider** le JSON exporté
2. ✅ **Archiver** le backup dans un lieu sûr
3. ✅ **Documenter** dans le journal de dev
4. 🔜 **Passer** à la leçon suivante si nécessaire

### Leçons dans le même groupe "La conjugaison"

Pour info, autres leçons du groupe à traiter éventuellement:
- Lesson 13: `la-conjugaison-du-verbe-etre-en-kikongo` ✅ (déjà corrigée)
- Lesson 14: `le-verbe-etre-dans-tous-ses-etats` ⏳ (en cours)
- Autres leçons: à identifier...

---

## 📚 Documentation complète

Pour plus de détails:
- **README technique**: [`README_LESSON14_CORRECTIONS.md`](./backend-java_factory-lessons_fixed/backend-java/SQL%20Files/README_LESSON14_CORRECTIONS.md)
- **Résumé**: [`RESUME_CORRECTION_LESSON14.md`](./RESUME_CORRECTION_LESSON14.md)
- **Index général**: [`INDEX_LESSON14.md`](./INDEX_LESSON14.md)
- **Flux visuel**: [`FLUX_CORRECTION_LESSON14.md`](./FLUX_CORRECTION_LESSON14.md)

---

## 🆘 Support

En cas de question ou problème:
1. Consulter [`README_LESSON14_CORRECTIONS.md`](./backend-java_factory-lessons_fixed/backend-java/SQL%20Files/README_LESSON14_CORRECTIONS.md)
2. Comparer avec la Leçon 13 (structure similaire)
3. Vérifier manuellement un exemple dans la base

**Requête de diagnostic**:
```sql
-- Voir le détail d'un exemple
SELECT 
  e.example_id,
  e.kg_text,
  e.fr_text,
  ear.code AS role,
  a.form,
  a.normalized_form
FROM examples e
LEFT JOIN example_atoms ea ON ea.example_id = e.example_id
LEFT JOIN atoms a ON a.atom_id = ea.atom_id
LEFT JOIN example_atom_roles ear ON ear.example_atom_role_id = ea.example_atom_role_id
WHERE e.lesson_ref_id = (SELECT lesson_ref_id FROM lesson_refs WHERE lesson_id=14 AND course_id=3)
ORDER BY e.example_id, ear.code;
```

---

**Version**: 1.0  
**Date**: 2026-02-14  
**Temps estimé**: 5 minutes
