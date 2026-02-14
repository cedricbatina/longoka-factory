# 📚 Index — Documentation Leçon 14

Ce répertoire contient tous les fichiers nécessaires pour corriger la **Leçon 14** du cours de Kikongo dans la base Factory.

## 🎯 Par où commencer?

Selon votre besoin, consultez:

### 1️⃣ Vous voulez une exécution rapide (5 min)
➡️ **Lisez**: [`GUIDE_RAPIDE_LESSON14.md`](./GUIDE_RAPIDE_LESSON14.md)
- Guide en 3 étapes
- Commandes prêtes à copier/coller
- Tableau récapitulatif des changements

### 2️⃣ Vous voulez comprendre le contexte complet
➡️ **Lisez**: [`RESUME_CORRECTION_LESSON14.md`](./RESUME_CORRECTION_LESSON14.md)
- Résumé exécutif
- Détails sur les 3 types de corrections
- Prochaines étapes après la correction
- Instructions backup/restore

### 3️⃣ Vous voulez les détails techniques
➡️ **Lisez**: [`backend-java_factory-lessons_fixed/backend-java/SQL Files/README_LESSON14_CORRECTIONS.md`](./backend-java_factory-lessons_fixed/backend-java/SQL%20Files/README_LESSON14_CORRECTIONS.md)
- Documentation technique complète
- Structure des tables concernées
- Répartition des rôles example_atoms
- Notes sur la sécurité et les performances
- Procédures de rollback détaillées

### 4️⃣ Vous voulez visualiser le flux
➡️ **Lisez**: [`FLUX_CORRECTION_LESSON14.md`](./FLUX_CORRECTION_LESSON14.md)
- Diagramme ASCII du flux de correction
- État AVANT → PENDANT → APRÈS
- Vue d'ensemble visuelle

## 📁 Fichiers disponibles

### Scripts SQL (à exécuter)

| Fichier | Description | Ordre d'exécution |
|---------|-------------|-------------------|
| [`factory_lesson14_verify.sql`](./backend-java_factory-lessons_fixed/backend-java/SQL%20Files/factory_lesson14_verify.sql) | Vérification (lecture seule) | 1️⃣ AVANT correction |
| [`factory_lesson14_fix_forms.sql`](./backend-java_factory-lessons_fixed/backend-java/SQL%20Files/factory_lesson14_fix_forms.sql) | Correction principale | 2️⃣ EXÉCUTION |
| [`factory_lesson14_verify.sql`](./backend-java_factory-lessons_fixed/backend-java/SQL%20Files/factory_lesson14_verify.sql) | Re-vérification | 3️⃣ APRÈS correction |

### Documentation

| Fichier | Type | Audience |
|---------|------|----------|
| `GUIDE_RAPIDE_LESSON14.md` | Guide rapide | Utilisateur pressé |
| `RESUME_CORRECTION_LESSON14.md` | Résumé | Chef de projet |
| `README_LESSON14_CORRECTIONS.md` | Technique | Développeur/DBA |
| `FLUX_CORRECTION_LESSON14.md` | Visuel | Toute audience |
| `INDEX_LESSON14.md` | Index | Point d'entrée |

## ⚡ Workflow recommandé

```
1. Lire ce fichier (INDEX_LESSON14.md)
   ↓
2. Consulter GUIDE_RAPIDE_LESSON14.md ou RESUME_CORRECTION_LESSON14.md
   ↓
3. Faire backup de la base (mysqldump)
   ↓
4. Exécuter factory_lesson14_verify.sql (état AVANT)
   ↓
5. Exécuter factory_lesson14_fix_forms.sql (CORRECTION)
   ↓
6. Exécuter factory_lesson14_verify.sql (état APRÈS)
   ↓
7. Exporter la leçon vers JSON (lesson-3-14.json)
   ↓
8. Copier vers "corrected kikongo course"
   ↓
9. Passer à la leçon suivante si nécessaire
```

## 🔍 Résumé des corrections

### Problèmes potentiels
- ❌ Exemples sans rôle "form" (à déterminer à l'exécution)
- ❌ Exemples avec plusieurs forms (à déterminer)
- ❌ Textes explicatifs en français (à identifier)

### Solutions appliquées
- ✅ Création automatique d'atoms "form" manquants
- ✅ Normalisation des exemples multi-forms
- ✅ Identification et suppression optionnelle des non-exemples

### Résultats attendus
| Métrique | Avant | Après |
|----------|-------|-------|
| Exemples sans form | N (≥0) | 0 |
| Exemples avec >1 form | M (≥0) | 0 |
| Forms valides | ? | 100% |

## 🛠️ Support technique

### En cas de problème
1. Vérifier que le backup existe
2. Relire `README_LESSON14_CORRECTIONS.md` section "Rollback"
3. Exécuter `factory_lesson14_verify.sql` pour diagnostiquer
4. Comparer avec la Leçon 13 (structure identique)

### Questions fréquentes

**Q: Le script est-il safe?**  
R: Oui, il inclut des vérifications avant/après. La suppression de texte français est commentée par défaut. Faites quand même un backup.

**Q: Puis-je le rejouer plusieurs fois?**  
R: Oui, il utilise INSERT IGNORE et UPDATE conditionnels. Mais ce n'est pas recommandé sans vérification préalable.

**Q: Dois-je modifier le script?**  
R: Non, il est prêt à l'emploi. Vous pouvez décommenter la section C si vous voulez supprimer les textes français (après validation manuelle).

**Q: Et si je veux annuler?**  
R: Restaurer depuis le backup MySQL (voir section Rollback dans README_LESSON14_CORRECTIONS.md).

**Q: Quelle différence avec la Leçon 13?**  
R: Aucune différence structurelle. Même pattern de correction, mais appliqué à la Leçon 14 (lesson_id=14).

## 📊 Statistiques

- **Lignes de code SQL**: ~420 (~190 verify + ~230 fix)
- **Lignes de documentation**: ~550 (README + Guide + Résumé)
- **Lignes de diagrammes**: ~155 (Flux)
- **Total**: ~1125 lignes
- **Temps d'exécution estimé**: < 5 secondes
- **Temps de lecture doc**: 10-30 minutes selon le niveau de détail souhaité

## 🎓 Contexte projet

- **Projet**: Longoka/Factory (cours de Kikongo)
- **Base de données**: 6i695q_factory_db
- **Leçon concernée**: Lesson 14 (lesson_id=14)
- **Titre**: Le verbe être dans tous ses états
- **Slug**: le-verbe-etre-dans-tous-ses-etats
- **Groupe**: La conjugaison
- **Position**: 6
- **Taxonomie**: Option B (atoms + examples + rules + example_atoms + relations)
- **Date**: Février 2026

## 🔗 Leçons liées

### Leçon 13 (référence)
- **Statut**: ✅ Corrigée avec succès
- **Pattern**: Identique à celui utilisé pour la Leçon 14
- **Problèmes résolus**: 16 exemples sans form, 1 avec 2 forms, 2 textes français supprimés
- **Documentation**: Disponible dans les fichiers `*_LESSON13.md`

### Autres leçons du groupe "La conjugaison"
À identifier via requête:
```sql
SELECT lesson_id, lesson_ref_id, title, slug, position
FROM lesson_refs
WHERE course_id=3 AND lesson_group='La conjugaison'
ORDER BY position;
```

## ➡️ Après cette leçon

Workflow de continuation:

1. ✅ Valider l'export JSON de la Leçon 14
2. ✅ Archiver le backup
3. ✅ Documenter dans le journal de dev
4. 🔜 Identifier la prochaine leçon à traiter (si applicable)

## 📦 Fichiers de sortie

Après exécution complète, vous aurez:

### Fichiers de log
- `lesson14_before.txt` — État avant corrections
- `lesson14_fix.txt` — Log des corrections appliquées
- `lesson14_after.txt` — État après corrections

### Fichiers de backup
- `backup_lesson14_YYYYMMDD_HHMMSS.sql` — Backup complet de la base

### Fichiers d'export
- `lesson-3-14.json` — Export JSON de la leçon corrigée

### Destination finale
```
D:/works/lectures/corrected kikongo course/La conjugaison/le-verbe-etre-dans-tous-ses-etats/
└── lesson-3-14.json
```

## 🔐 Sécurité

### Backups
- ✅ Obligatoire avant toute modification
- ✅ Format: SQL dump complet ou tables sélectionnées
- ✅ Conservation: Archiver dans un lieu sûr après validation

### Scripts
- ✅ `verify`: READ-ONLY, safe à tout moment
- ⚠️ `fix`: MODIFIE la base, backup obligatoire
- ✅ Suppressions: Commentées par défaut (sécurité)

### Validation
- ✅ Comparaison AVANT/APRÈS obligatoire
- ✅ Validation JSON recommandée
- ✅ Tests manuels sur échantillon (optionnel)

## 🎯 Commandes rapides

### Vérification rapide
```bash
cd backend-java_factory-lessons_fixed/backend-java/SQL\ Files
mysql -u [user] -p 6i695q_factory_db < factory_lesson14_verify.sql | grep -A5 "SUMMARY"
```

### Correction + Vérification
```bash
mysql -u [user] -p 6i695q_factory_db < factory_lesson14_fix_forms.sql
mysql -u [user] -p 6i695q_factory_db < factory_lesson14_verify.sql | grep "✅"
```

### Export JSON
```bash
cd ../../
mvn -q package
java -cp target/backend-java-1.0-SNAPSHOT-jar-with-dependencies.jar \
  com.longoka.games.app.FactoryLessonPackJsonExportTool \
  --course 3 --lesson 14 --out ../../lesson-3-14.json
```

## 📖 Conventions

### Nommage des fichiers
- `factory_lesson14_*.sql` — Scripts SQL pour la Leçon 14
- `*_LESSON14.md` — Documentation Markdown pour la Leçon 14
- `lesson-3-14.json` — Export JSON (course 3, lesson 14)

### Structure de documentation
- `INDEX_LESSON14.md` — Point d'entrée (ce fichier)
- `GUIDE_RAPIDE_LESSON14.md` — Guide utilisateur rapide
- `RESUME_CORRECTION_LESSON14.md` — Résumé pour managers
- `README_LESSON14_CORRECTIONS.md` — Documentation technique complète
- `FLUX_CORRECTION_LESSON14.md` — Diagramme visuel

## 🌟 Avantages de cette approche

1. **Automatisation**: Script SQL réutilisable
2. **Sécurité**: Vérifications avant/après, backups obligatoires
3. **Traçabilité**: Logs complets, comparaison AVANT/APRÈS
4. **Documentation**: 4 niveaux de détail selon le besoin
5. **Idempotence**: Peut être rejoué sans danger
6. **Pattern éprouvé**: Basé sur la Leçon 13 (validée)

---

**Version**: 1.0  
**Dernière mise à jour**: 2026-02-14  
**Auteur**: Correction automatique via GitHub Copilot  
**Statut**: ✅ Prêt pour utilisation
