# Lesson 13 Corrections — La conjugaison du verbe être

## Contexte

**Leçon traitée**: Course 3 — Lesson 13 (Factory `lesson_ref_id=6`)  
**Titre**: La conjugaison du verbe être en kikongo  
**Date de correction**: Février 2026

## Problèmes détectés

### 1. Exemples sans rôle "form" (16 exemples)

14 exemples où la forme conjuguée (le dernier mot) n'était pas reliée comme atom form:

- example_id 367: `ku Mbanza Kinsasa ukele` → forme manquante: `ukele`
- example_id 369: `ku Mbanza Wiida wukele` → forme manquante: `wukele`
- example_id 371: `ku Mbanza Kisangani lukele` → forme manquante: `lukele`
- example_id 380: `ku n'kelo widi` → forme manquante: `widi`
- example_id 384: `ku Mbanza Mvenge luidi` → forme manquante: `luidi`
- example_id 386: `ku dizi udi` → forme manquante: `udi`
- example_id 387: `ku nima kadi` → forme manquante: `kadi`
- example_id 388: `ku ntuala wudi` → forme manquante: `wudi`
- example_id 389: `ku londe tudi` → forme manquante: `tudi`
- example_id 390: `ku Mbanza Kananga ludi` → forme manquante: `ludi`
- example_id 391: `ku Mbanza Bandaka badi` → forme manquante: `badi`
- example_id 393: `ku Mbanza Kinsasa ukadi` → forme manquante: `ukadi`
- example_id 395: `ku Mbanza Wiida wukadi` → forme manquante: `wukadi`
- example_id 397: `ku Mbanza Kisangani lukadi` → forme manquante: `lukadi`

2 exemples de texte explicatif en français (pas de vrais exemples):
- example_id 366: `"ka se conjugue en changeant sa terminaison a..."`
- example_id 392: `"kala se conjugue en changeant sa terminaison ala..."`

### 2. Exemple avec 2 forms (1 exemple)

- example_id 348: avait 2 atoms marqués comme "form" au lieu d'un seul
  - Solution: garder `uena` comme form principal, les autres deviennent `variant_form`

## Solution appliquée

Le script SQL `factory_lesson13_fix_forms.sql` effectue les corrections suivantes:

### A) Normalisation de l'exemple 348
- Identifie l'atom `uena` comme forme principale
- Convertit tous les autres forms en `variant_form`
- Remet `uena` en tant que seul `form`

### B) Création et liaison des forms manquants
- Extrait le dernier mot de chaque `kg_text` sans form
- Crée les atoms manquants dans la table `atoms`
- Lie ces atoms aux exemples avec le rôle `form`
- Exclut les lignes contenant "se conjugue" (texte explicatif français)

### C) Gestion des exemples 366 et 392
- Supprime ces 2 exemples car ils ne sont pas de vrais exemples de conjugaison
- Ce sont des notes explicatives qui devraient être converties en `lesson_rules` ou `chips`

## Exécution du script

### Pré-requis
- Accès à la base de données Factory: `6i695q_factory_db`
- Privilèges: SELECT, INSERT, UPDATE, DELETE sur les tables concernées

### Étapes d'exécution

1. **Audit pré-correction** (inclus dans le script):
   ```sql
   -- Exécuter les requêtes PRE-FLIGHT CHECKS
   -- pour vérifier l'état avant correction
   ```

2. **Appliquer les corrections**:
   ```bash
   # Via MySQL CLI
   mysql -h 6i695q.myd.infomaniak.com -u 6i695q_cedric -p 6i695q_factory_db < factory_lesson13_fix_forms.sql
   
   # Ou via phpMyAdmin: Import > factory_lesson13_fix_forms.sql
   ```

3. **Vérification post-correction** (inclus dans le script):
   ```sql
   -- Exécuter les requêtes POST-FLIGHT VERIFICATION
   -- pour confirmer que tout est corrigé
   ```

### Résultats attendus

Avant correction:
- chips: 9
- examples: 59
- lesson_atoms: 29
- lesson_rules: 6
- example_atoms: 173
- Exemples sans form: 16
- Exemples avec >1 form: 1

Après correction:
- chips: 9 (inchangé)
- examples: 57 (59 - 2 supprimés)
- lesson_atoms: 29 (inchangé)
- lesson_rules: 6 (inchangé)
- example_atoms: ~185 (+14 forms créés, -2 exemples supprimés)
- Exemples sans form: 0 ✅
- Exemples avec >1 form: 0 ✅

## Export de la leçon corrigée

Une fois les corrections appliquées, exporter la leçon vers le dossier "corrected kikongo course":

```bash
cd D:\works\lectures\longoka\scripts

node .\export-lesson-to-corrected.mjs \
  --slug la-conjugaison-du-verbe-etre-en-kikongo \
  --db-name 6i695q_longoka \
  --out-dir "D:\works\lectures\corrected kikongo course\La conjugaison\lesson-13-la-conjugaison-du-verbe-etre"
```

## Prochaine leçon

Après l'export de la leçon 13, traiter la leçon suivante:

**Leçon**: Les temps futurs du kikongo classique  
**Slug**: `les-temps-futurs-du-kikongo-classique`  
**Export directory**: `D:\works\lectures\corrected kikongo course\La conjugaison\les-temps-futurs-du-kikongo-classique\`

```bash
node .\export-lesson-to-corrected.mjs \
  --slug les-temps-futurs-du-kikongo-classique \
  --db-name 6i695q_longoka \
  --out-dir "D:\works\lectures\corrected kikongo course\La conjugaison\les-temps-futurs-du-kikongo-classique"
```

## Notes techniques

### Tables concernées
- `examples`: contient les exemples (kg_text, fr_text, etc.)
- `atoms`: contient les unités linguistiques (mots, syllabes, etc.)
- `example_atoms`: lie les examples aux atoms avec un rôle
- `example_atom_roles`: définit les rôles (form, auxiliary, subject_prefix, etc.)

### Rôles des example_atoms (pour leçon 6)
Distribution après correction:
- form: 57 (44 + 14 nouveaux - 1 converti en variant)
- auxiliary: 43
- subject_prefix: 42
- suffix: 24
- particle: 13
- variant_form: 8 (7 + 1 converti depuis form)

### Relations atom_relations
Non modifiées par ce script:
- composed_of: 103
- has_prefix: 37
- has_suffix: 23
- variant_of: 16
- agrees_with: 3
- derived_from: 3

### Tags appliqués
Non modifiés par ce script:
- Tag IDs: grammar:conjugation=10, grammar:copula=11, grammar:verb-etre=12
- 60 atoms distincts taggés avec les 3 tags

## Warnings attendus

Le script peut générer des warnings MySQL normaux:
- `#1062` sur `INSERT IGNORE`: doublons ignorés (comportement attendu)
- `#1364` sur `INSERT INTO rules`: champ language_code sans valeur par défaut (peut être ignoré si la règle existe déjà)

## Rollback

En cas de problème, restaurer depuis une sauvegarde de la base:
```bash
# Backup avant correction
mysqldump -h 6i695q.myd.infomaniak.com -u 6i695q_cedric -p 6i695q_factory_db > backup_lesson13_before_fix.sql

# Restore si besoin
mysql -h 6i695q.myd.infomaniak.com -u 6i695q_cedric -p 6i695q_factory_db < backup_lesson13_before_fix.sql
```

## Références

- Base de données Factory: `6i695q_factory_db`
- Leçon dans Longoka: `6i695q_longoka` (base séparée pour l'export)
- Documentation projet: voir fichiers `bilan_factory_db_*.txt` dans le repo
- Taxonomie: Option B (atoms + examples + rules + example_atoms + relations)
