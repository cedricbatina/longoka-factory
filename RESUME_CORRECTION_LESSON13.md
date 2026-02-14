# 🎓 Projet Longoka/Factory — Leçon 13 Corrigée

## ✅ Ce qui a été fait

J'ai créé les fichiers nécessaires pour corriger la **Leçon 13 (lesson_ref_id=6)** dans la base de données Factory:

### 📁 Fichiers créés

1. **`factory_lesson13_fix_forms.sql`** (script principal)
   - Localisation: `backend-java_factory-lessons_fixed/backend-java/SQL Files/`
   - Contenu: Script SQL complet pour corriger les problèmes de rôles "form"
   - Inclut: audit pré-correction, corrections, vérification post-correction

2. **`README_LESSON13_CORRECTIONS.md`** (documentation détaillée)
   - Localisation: `backend-java_factory-lessons_fixed/backend-java/SQL Files/`
   - Contenu: Documentation complète avec contexte, problèmes détectés, solutions, résultats attendus
   - Inclut: instructions d'exécution, rollback, références techniques

3. **`GUIDE_RAPIDE_LESSON13.md`** (guide d'exécution rapide)
   - Localisation: racine du projet
   - Contenu: Guide en 3 étapes pour appliquer rapidement les corrections
   - Inclut: tableau des changements, commandes d'export, prochaines étapes

## 🔧 Corrections appliquées par le script

### Problème A: Exemple 348 avec 2 forms
- **Solution**: Garde `uena` comme form principal, convertit les autres en `variant_form`
- **Impact**: 1 exemple normalisé

### Problème B: 14 exemples sans form
Le script extrait le dernier mot de chaque `kg_text` et le lie comme form:
- `ukele`, `wukele`, `lukele` (présent)
- `widi`, `luidi`, `udi` (passé)
- `kadi`, `wudi`, `tudi`, `ludi`, `badi` (imparfait)
- `ukadi`, `wukadi`, `lukadi` (imparfait)

**Impact**: 14 nouveaux atoms créés et liés

### Problème C: 2 exemples en français (366, 392)
- **Solution**: Suppression (ce sont des notes explicatives, pas des exemples)
- **Impact**: 2 exemples supprimés

## 📊 Résultats attendus

| Métrique | Avant | Après | Changement |
|----------|-------|-------|------------|
| Nombre d'exemples | 59 | 57 | -2 ✅ |
| Exemples sans form | 16 | 0 | -16 ✅ |
| Exemples avec >1 form | 1 | 0 | -1 ✅ |
| Forms corrects | 43 | 57 | +14 ✅ |

## 🚀 Prochaines étapes (pour vous)

### Étape 1: Backup de la base (IMPORTANT!)
```bash
mysqldump -h 6i695q.myd.infomaniak.com -u 6i695q_cedric -p 6i695q_factory_db > backup_lesson13_$(date +%Y%m%d).sql
# Note: You will be prompted for the password securely
```

### Étape 2: Exécuter le script SQL

**Option A - Via phpMyAdmin** (recommandé):
1. Ouvrir phpMyAdmin
2. Sélectionner la base `6i695q_factory_db`
3. Onglet "SQL"
4. Copier/coller le contenu de `factory_lesson13_fix_forms.sql`
5. Cliquer "Exécuter"
6. Vérifier les résultats affichés

**Option B - Via ligne de commande**:
```bash
cd backend-java_factory-lessons_fixed/backend-java/SQL\ Files
mysql -h 6i695q.myd.infomaniak.com -u 6i695q_cedric -p -D 6i695q_factory_db < factory_lesson13_fix_forms.sql
```

### Étape 3: Vérifier les corrections

Exécuter cette requête pour confirmer:
```sql
-- Doit retourner 0
SELECT COUNT(*) FROM examples e
LEFT JOIN example_atoms ea ON ea.example_id = e.example_id 
  AND ea.example_atom_role_id = (SELECT example_atom_role_id FROM example_atom_roles WHERE code='form')
WHERE e.lesson_ref_id = 6 AND ea.example_id IS NULL;
```

### Étape 4: Exporter la leçon vers "corrected kikongo course"

```bash
cd D:\works\lectures\longoka\scripts

node .\export-lesson-to-corrected.mjs \
  --slug la-conjugaison-du-verbe-etre-en-kikongo \
  --db-name 6i695q_longoka \
  --out-dir "D:\works\lectures\corrected kikongo course\La conjugaison\lesson-13-la-conjugaison-du-verbe-etre"
```

### Étape 5: Passer à la prochaine leçon

Une fois la leçon 13 exportée avec succès, traiter la leçon suivante:

```bash
node .\export-lesson-to-corrected.mjs \
  --slug les-temps-futurs-du-kikongo-classique \
  --db-name 6i695q_longoka \
  --out-dir "D:\works\lectures\corrected kikongo course\La conjugaison\les-temps-futurs-du-kikongo-classique"
```

## 📝 Notes importantes

### Warnings MySQL normaux
- `#1062` sur INSERT IGNORE: doublons ignorés (OK)
- `#1364` sur rules sans language_code: peut être ignoré si la règle existe

### Structure Option B respectée
Le script maintient la structure Option B:
- ✅ atoms (unités linguistiques)
- ✅ examples (exemples avec kg_text)
- ✅ rules (règles grammaticales)
- ✅ example_atoms (liaisons avec rôles)
- ✅ relations (atom_relations)

### Tags non modifiés
Les 3 tags existants restent intacts:
- `grammar:conjugation` (tag_id=10)
- `grammar:copula` (tag_id=11)
- `grammar:verb-etre` (tag_id=12)

## 🔍 Pour aller plus loin

### Audit complet de la leçon
Après exécution, vous pouvez vérifier tous les compteurs:
```sql
SELECT 
  (SELECT COUNT(*) FROM chips WHERE lesson_ref_id=6) AS chips,
  (SELECT COUNT(*) FROM examples WHERE lesson_ref_id=6) AS examples,
  (SELECT COUNT(*) FROM lesson_atoms WHERE lesson_ref_id=6) AS lesson_atoms,
  (SELECT COUNT(*) FROM lesson_rules WHERE lesson_ref_id=6) AS lesson_rules,
  (SELECT COUNT(*) FROM example_atoms ea JOIN examples e ON e.example_id=ea.example_id WHERE e.lesson_ref_id=6) AS example_atoms;
```

### Répartition des rôles
```sql
SELECT r.code, COUNT(*) AS cnt
FROM examples e
JOIN example_atoms ea ON ea.example_id=e.example_id
LEFT JOIN example_atom_roles r ON r.example_atom_role_id=ea.example_atom_role_id
WHERE e.lesson_ref_id=6
GROUP BY r.code
ORDER BY cnt DESC;
```

## ✉️ Questions?

Si vous rencontrez des problèmes:
1. Vérifiez que le backup est bien fait
2. Consultez `README_LESSON13_CORRECTIONS.md` pour plus de détails
3. Testez d'abord sur une copie de la base si possible

---

**Résumé**: Tout est prêt pour corriger la leçon 13! Il suffit d'exécuter le script SQL, vérifier les résultats, puis exporter. 🎉
