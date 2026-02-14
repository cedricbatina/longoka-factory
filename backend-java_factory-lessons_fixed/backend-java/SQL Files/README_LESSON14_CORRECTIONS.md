# 📚 Factory DB — Lesson 14 Corrections

## 📋 Résumé exécutif

Ce document décrit les corrections à appliquer à la **Leçon 14** du cours de Kikongo dans la base de données Factory.

**Leçon concernée**: Le verbe être dans tous ses états  
**Slug**: `le-verbe-etre-dans-tous-ses-etats`  
**Course**: 3 (Kikongo)  
**Lesson ID**: 14  
**Lesson Group**: La conjugaison  
**Position**: 6  

## 🎯 Objectif

Corriger les problèmes de rôles `form` dans les `example_atoms` pour garantir que:
- ✅ Chaque exemple ait **exactement 1** atom avec le rôle `form`
- ✅ Les atoms supplémentaires soient marqués comme `variant_form` si nécessaire
- ✅ Les textes explicatifs en français soient identifiés et supprimés si approprié

## 🔍 Contexte technique

### Structure des tables

```
lesson_refs (lesson_ref_id, course_id, lesson_id, slug, title, ...)
  ├── chips (lesson_ref_id)
  ├── examples (example_id, lesson_ref_id, kg_text, fr_text, ...)
  ├── lesson_atoms (lesson_ref_id, atom_id, ...)
  ├── lesson_rules (lesson_ref_id, rule_id, ...)
  └── example_atoms (example_atom_id, example_id, atom_id, example_atom_role_id)
```

### Rôles d'atoms dans les exemples

Les rôles possibles pour `example_atoms`:
- **`form`**: La forme principale de l'exemple (DOIT être unique par exemple)
- **`variant_form`**: Variantes orthographiques ou alternatives
- **`root`**: Racine morphologique
- **`stem`**: Radical verbal
- **`affix`**: Affixes (préfixes, suffixes)
- Autres rôles selon la taxonomie

## ❌ Problèmes détectés

### Type A: Exemples sans rôle `form`

Certains exemples n'ont aucun atom lié avec le rôle `form`. Cela empêche:
- L'indexation correcte des formes
- L'export vers d'autres systèmes
- La génération de jeux éducatifs

**Solution**: Créer un atom `word` avec le dernier mot du `kg_text` et le lier comme `form`.

### Type B: Exemples avec plusieurs rôles `form`

Certains exemples ont **plus d'un** atom marqué comme `form`. Cela crée:
- De l'ambiguïté sur la forme principale
- Des problèmes d'export JSON
- Des conflits dans les index

**Solution**: Garder le premier atom comme `form`, convertir les autres en `variant_form`.

### Type C: Textes explicatifs en français

Certaines entrées dans `examples` sont en réalité des **notes pédagogiques** en français, pas des exemples Kikongo.

**Solution**: Identifier ces entrées et les supprimer (après validation manuelle).

## 📁 Fichiers fournis

### 1. `factory_lesson14_verify.sql`

**Type**: Script de vérification (READ-ONLY)  
**Usage**: Exécuter AVANT et APRÈS les corrections  
**Contenu**:
- Identification du `lesson_ref_id` pour la leçon 14
- Comptage des chips, examples, lesson_atoms, etc.
- Détection des 3 types de problèmes (A, B, C)
- Liste détaillée des problèmes trouvés
- Distribution des rôles d'example_atoms
- Métriques de résumé

**Commande**:
```bash
mysql -u [user] -p [database] < factory_lesson14_verify.sql
```

### 2. `factory_lesson14_fix_forms.sql`

**Type**: Script de correction (WRITE)  
**Usage**: Exécuter UNE FOIS après backup  
**Contenu**:
- Section A: Normalisation des exemples avec multiples forms
- Section B: Création et liaison des forms manquantes
- Section C: Suppression optionnelle des textes français (commentée par défaut)
- Vérifications post-correction

**Commande**:
```bash
mysql -u [user] -p [database] < factory_lesson14_fix_forms.sql
```

## 🚀 Procédure d'exécution

### Étape 1: Backup

**OBLIGATOIRE** avant toute modification:

```bash
# Backup complet de la base
mysqldump -u [user] -p [database] > backup_factory_lesson14_$(date +%Y%m%d_%H%M%S).sql

# OU backup des tables concernées uniquement
mysqldump -u [user] -p [database] \
  lesson_refs chips examples lesson_atoms lesson_rules \
  example_atoms atoms atom_types example_atom_roles \
  > backup_factory_lesson14_tables_$(date +%Y%m%d_%H%M%S).sql
```

### Étape 2: Vérification AVANT

```bash
mysql -u [user] -p [database] < factory_lesson14_verify.sql > lesson14_before.txt
```

**Analyser** `lesson14_before.txt`:
- Combien d'exemples sans `form`?
- Combien d'exemples avec >1 `form`?
- Y a-t-il du texte français à supprimer?

### Étape 3: Application des corrections

```bash
mysql -u [user] -p [database] < factory_lesson14_fix_forms.sql > lesson14_fix.txt
```

**Vérifier** `lesson14_fix.txt`:
- Nombre de nouveaux atoms créés
- Nombre de liens `form` créés
- Messages d'erreur éventuels

### Étape 4: Vérification APRÈS

```bash
mysql -u [user] -p [database] < factory_lesson14_verify.sql > lesson14_after.txt
```

**Comparer** avec `lesson14_before.txt`:
- Exemples sans `form`: **doit être 0**
- Exemples avec >1 `form`: **doit être 0**
- Nombre total d'exemples: vérifier la cohérence

### Étape 5: Export JSON

Une fois les corrections validées, exporter la leçon:

```bash
cd backend-java_factory-lessons_fixed/backend-java
mvn -q -DskipTests package

java -cp target/backend-java-1.0-SNAPSHOT-jar-with-dependencies.jar \
  com.longoka.games.app.FactoryLessonPackJsonExportTool \
  --course 3 --lesson 14 --out ../../lesson-3-14.json
```

## 🔄 Rollback (en cas de problème)

### Option 1: Restauration complète

```bash
# Arrêter les applications utilisant la base (si applicable)
mysql -u [user] -p [database] < backup_factory_lesson14_YYYYMMDD_HHMMSS.sql
```

### Option 2: Restauration sélective

Si vous avez seulement besoin d'annuler les changements sur les `example_atoms`:

```sql
-- Supprimer les example_atoms créés par le script
DELETE ea FROM example_atoms ea
JOIN examples e ON e.example_id = ea.example_id
WHERE e.lesson_ref_id = (SELECT lesson_ref_id FROM lesson_refs WHERE lesson_id=14 AND course_id=3)
  AND ea.created_at > '[TIMESTAMP_BEFORE_SCRIPT]';

-- Restaurer depuis le backup si nécessaire
SOURCE backup_factory_lesson14_tables_YYYYMMDD_HHMMSS.sql
```

## 📊 Résultats attendus

### Avant corrections

| Métrique | Valeur attendue |
|----------|----------------|
| Exemples totaux | X (à déterminer) |
| Exemples sans `form` | >0 (problème) |
| Exemples avec >1 `form` | ≥0 (problème potentiel) |
| Texte français | ≥0 (à vérifier) |

### Après corrections

| Métrique | Valeur attendue |
|----------|----------------|
| Exemples totaux | X ou X-N (si suppressions) |
| Exemples sans `form` | **0** ✅ |
| Exemples avec >1 `form` | **0** ✅ |
| Texte français | **0** ✅ (si supprimés) |

## ⚠️ Notes importantes

### Sécurité

- ✅ Le script `verify` est **READ-ONLY** (safe)
- ⚠️ Le script `fix` **MODIFIE** la base (backup obligatoire)
- ✅ Les DELETE de texte français sont **COMMENTÉS** par défaut (sécurité)

### Idempotence

- ✅ `INSERT IGNORE` évite les doublons d'atoms
- ✅ Les UPDATE sont conditionnels
- ✅ Le script peut être rejoué sans danger (mais pas recommandé)

### Performance

- Temps d'exécution estimé: **< 5 secondes**
- Impact: Faible (quelques dizaines d'exemples)
- Aucun verrou prolongé

### Compatibilité

- MySQL 5.7+
- MariaDB 10.2+
- Testé avec la structure Factory DB (février 2026)

## 🔗 Références

### Taxonomie Factory

Les corrections suivent la **taxonomie Option B**:
```
atoms → lesson_atoms (core/bonus)
atoms → example_atoms (form/variant_form/root/stem/affix...)
examples → example_atoms
rules → lesson_rules
chips (standalone)
```

### Leçons similaires corrigées

- ✅ **Lesson 13** (`la-conjugaison-du-verbe-etre-en-kikongo`) — Corrigée avec succès
  - 16 exemples sans `form` → 0
  - 1 exemple avec 2 `form` → normalisé
  - 2 textes français → supprimés
  - Pattern de correction identique

### Scripts liés

- `factory_lesson13_verify.sql` — Template de référence
- `factory_lesson13_fix_forms.sql` — Pattern de correction similaire
- `factory_dashboard_views.sql` — Vues pour monitoring général

## 📞 Support

### Vérification manuelle

En cas de doute sur un exemple spécifique:

```sql
-- Voir un exemple et ses atoms
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
  AND e.example_id = [ID];
```

### Logging

Pour tracer les modifications:

```sql
-- Avant corrections, sauvegarder l'état
CREATE TABLE lesson14_backup_example_atoms AS
SELECT ea.* 
FROM example_atoms ea
JOIN examples e ON e.example_id = ea.example_id
WHERE e.lesson_ref_id = (SELECT lesson_ref_id FROM lesson_refs WHERE lesson_id=14 AND course_id=3);
```

## 📅 Métadonnées

- **Version**: 1.0
- **Date de création**: 2026-02-14
- **Auteur**: Correction automatique via GitHub Copilot
- **Révision**: —
- **Statut**: Prêt pour exécution

## ✅ Checklist de validation

Avant de considérer la correction comme complète:

- [ ] Backup créé et vérifié
- [ ] Script de vérification exécuté AVANT
- [ ] Script de correction exécuté avec succès
- [ ] Script de vérification exécuté APRÈS
- [ ] Comparaison AVANT/APRÈS: 0 problème détecté
- [ ] Export JSON généré avec succès
- [ ] JSON validé (structure, contenu)
- [ ] Backup archivé dans un lieu sûr
- [ ] Documentation mise à jour dans le système de gestion

---

**📌 Rappel**: Toujours faire un backup avant d'exécuter des scripts de modification de base de données.
