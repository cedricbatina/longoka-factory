# Guide rapide — Correction Leçon 13 et Export

## 🎯 Objectif
Corriger les problèmes de rôles "form" dans la leçon 13 (conjugaison du verbe être), puis exporter vers le dossier "corrected kikongo course".

## ⚡ Exécution rapide (3 étapes)

### 1. Appliquer les corrections SQL

**Via phpMyAdmin**:
1. Ouvrir phpMyAdmin → Base `6i695q_factory_db`
2. Onglet SQL
3. Copier/coller le contenu de `factory_lesson13_fix_forms.sql`
4. Cliquer "Exécuter"

**Via ligne de commande**:
```bash
cd backend-java_factory-lessons_fixed/backend-java/SQL\ Files
mysql -h 6i695q.myd.infomaniak.com -u 6i695q_cedric -p -D 6i695q_factory_db < factory_lesson13_fix_forms.sql
# Note: You will be prompted for the password securely
```

### 2. Vérifier les résultats

Exécuter cette requête pour confirmer que tout est OK:
```sql
-- Doit retourner 0
SELECT COUNT(*) AS examples_sans_form
FROM examples e
LEFT JOIN example_atoms ea ON ea.example_id = e.example_id 
  AND ea.example_atom_role_id = (SELECT example_atom_role_id FROM example_atom_roles WHERE code='form' LIMIT 1)
WHERE e.lesson_ref_id = 6 AND ea.example_id IS NULL;

-- Doit retourner 57 (au lieu de 59)
SELECT COUNT(*) AS total_examples FROM examples WHERE lesson_ref_id = 6;
```

### 3. Exporter la leçon

```bash
cd D:\works\lectures\longoka\scripts

node .\export-lesson-to-corrected.mjs --slug la-conjugaison-du-verbe-etre-en-kikongo --db-name 6i695q_longoka --out-dir "D:\works\lectures\corrected kikongo course\La conjugaison\lesson-13-la-conjugaison-du-verbe-etre"
```

## 📊 Changements appliqués

| Métrique | Avant | Après | Δ |
|----------|-------|-------|---|
| Exemples | 59 | 57 | -2 |
| Exemples sans form | 16 | 0 | -16 |
| Exemples avec >1 form | 1 | 0 | -1 |
| Forms créés | - | +14 | +14 |

## 🔍 Détails des corrections

1. **Exemple 348**: normalisé (1 seul form au lieu de 2)
2. **14 nouveaux forms**: créés et liés (dernier mot de kg_text)
3. **Exemples 366 & 392**: supprimés (texte explicatif français)

## ➡️ Prochaine leçon

Après validation de la leçon 13, traiter:
- **Slug**: `les-temps-futurs-du-kikongo-classique`
- **Export**: `D:\works\lectures\corrected kikongo course\La conjugaison\les-temps-futurs-du-kikongo-classique\`

```bash
node .\export-lesson-to-corrected.mjs --slug les-temps-futurs-du-kikongo-classique --db-name 6i695q_longoka --out-dir "D:\works\lectures\corrected kikongo course\La conjugaison\les-temps-futurs-du-kikongo-classique"
```

## 📚 Documentation complète

Voir `README_LESSON13_CORRECTIONS.md` pour:
- Détails techniques complets
- Liste exhaustive des 16 exemples corrigés
- Instructions de rollback
- Schéma des tables concernées

## ⚠️ Important

- Faire un backup avant d'exécuter: `mysqldump ... > backup.sql`
- Les warnings MySQL #1062 (doublons) sont normaux avec INSERT IGNORE
- Vérifier les counts après exécution (queries incluses dans le script)
