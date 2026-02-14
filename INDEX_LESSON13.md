# 📚 Index — Documentation Leçon 13

Ce répertoire contient tous les fichiers nécessaires pour corriger la **Leçon 13** du cours de Kikongo dans la base Factory.

## 🎯 Par où commencer?

Selon votre besoin, consultez:

### 1️⃣ Vous voulez une exécution rapide (5 min)
➡️ **Lisez**: [`GUIDE_RAPIDE_LESSON13.md`](./GUIDE_RAPIDE_LESSON13.md)
- Guide en 3 étapes
- Commandes prêtes à copier/coller
- Tableau récapitulatif des changements

### 2️⃣ Vous voulez comprendre le contexte complet
➡️ **Lisez**: [`RESUME_CORRECTION_LESSON13.md`](./RESUME_CORRECTION_LESSON13.md)
- Résumé exécutif
- Détails sur les 3 types de corrections
- Prochaines étapes après la correction
- Instructions backup/restore

### 3️⃣ Vous voulez les détails techniques
➡️ **Lisez**: [`backend-java_factory-lessons_fixed/backend-java/SQL Files/README_LESSON13_CORRECTIONS.md`](./backend-java_factory-lessons_fixed/backend-java/SQL%20Files/README_LESSON13_CORRECTIONS.md)
- Documentation technique complète
- Liste exhaustive des 16 exemples corrigés
- Structure des tables concernées
- Répartition des rôles example_atoms
- Notes sur les warnings MySQL

### 4️⃣ Vous voulez visualiser le flux
➡️ **Lisez**: [`FLUX_CORRECTION_LESSON13.md`](./FLUX_CORRECTION_LESSON13.md)
- Diagramme ASCII du flux de correction
- État AVANT → PENDANT → APRÈS
- Vue d'ensemble visuelle

## 📁 Fichiers disponibles

### Scripts SQL (à exécuter)

| Fichier | Description | Ordre d'exécution |
|---------|-------------|-------------------|
| [`factory_lesson13_verify.sql`](./backend-java_factory-lessons_fixed/backend-java/SQL%20Files/factory_lesson13_verify.sql) | Vérification (lecture seule) | 1️⃣ AVANT correction |
| [`factory_lesson13_fix_forms.sql`](./backend-java_factory-lessons_fixed/backend-java/SQL%20Files/factory_lesson13_fix_forms.sql) | Correction principale | 2️⃣ EXÉCUTION |
| [`factory_lesson13_verify.sql`](./backend-java_factory-lessons_fixed/backend-java/SQL%20Files/factory_lesson13_verify.sql) | Re-vérification | 3️⃣ APRÈS correction |

### Documentation

| Fichier | Type | Audience |
|---------|------|----------|
| `GUIDE_RAPIDE_LESSON13.md` | Guide rapide | Utilisateur pressé |
| `RESUME_CORRECTION_LESSON13.md` | Résumé | Chef de projet |
| `README_LESSON13_CORRECTIONS.md` | Technique | Développeur/DBA |
| `FLUX_CORRECTION_LESSON13.md` | Visuel | Toute audience |
| `INDEX_LESSON13.md` | Index | Point d'entrée |

## ⚡ Workflow recommandé

```
1. Lire ce fichier (INDEX_LESSON13.md)
   ↓
2. Consulter GUIDE_RAPIDE_LESSON13.md ou RESUME_CORRECTION_LESSON13.md
   ↓
3. Faire backup de la base (mysqldump)
   ↓
4. Exécuter factory_lesson13_verify.sql (état AVANT)
   ↓
5. Exécuter factory_lesson13_fix_forms.sql (CORRECTION)
   ↓
6. Exécuter factory_lesson13_verify.sql (état APRÈS)
   ↓
7. Exporter la leçon vers "corrected kikongo course"
   ↓
8. Passer à la leçon suivante (les-temps-futurs...)
```

## 🔍 Résumé des corrections

### Problèmes détectés
- ❌ 16 exemples sans rôle "form"
- ❌ 1 exemple avec 2 forms (au lieu de 1)
- ❌ 2 exemples en français (texte explicatif)

### Solutions appliquées
- ✅ Création de 14 nouveaux atoms "form"
- ✅ Normalisation de l'exemple 348
- ✅ Suppression des 2 exemples en français

### Résultats attendus
| Métrique | Avant | Après |
|----------|-------|-------|
| Exemples | 59 | 57 |
| Sans form | 16 | 0 |
| Avec >1 form | 1 | 0 |

## 🛠️ Support technique

### En cas de problème
1. Vérifier que le backup existe
2. Relire `README_LESSON13_CORRECTIONS.md` section "Rollback"
3. Exécuter `factory_lesson13_verify.sql` pour diagnostiquer

### Questions fréquentes

**Q: Le script est-il safe?**  
R: Oui, il inclut des vérifications avant/après. Faites quand même un backup.

**Q: Puis-je le rejouer plusieurs fois?**  
R: Oui, il utilise INSERT IGNORE et UPDATE conditionnels.

**Q: Dois-je modifier le script?**  
R: Non, il est prêt à l'emploi. Peut-être commenter/décommenter le DELETE si vous voulez garder les exemples 366/392.

**Q: Et si je veux annuler?**  
R: Restaurer depuis le backup MySQL (voir section Rollback dans README_LESSON13_CORRECTIONS.md).

## 📊 Statistiques

- **Lignes de code SQL**: 383 (171 fix + 212 verify)
- **Lignes de documentation**: 430 (187 + 82 + 161)
- **Lignes de diagrammes**: 155
- **Total**: 968 lignes
- **Temps d'exécution estimé**: < 5 secondes
- **Temps de lecture doc**: 10-30 minutes selon le niveau de détail souhaité

## 🎓 Contexte projet

- **Projet**: Longoka/Factory (cours de Kikongo)
- **Base de données**: 6i695q_factory_db
- **Leçon concernée**: Lesson 13 (lesson_ref_id=6)
- **Titre**: La conjugaison du verbe être en kikongo
- **Taxonomie**: Option B (atoms + examples + rules + example_atoms + relations)
- **Date**: Février 2026

## ➡️ Après cette leçon

Prochaine leçon à traiter:
- **Slug**: `les-temps-futurs-du-kikongo-classique`
- **Export dir**: `D:/works/lectures/corrected kikongo course/La conjugaison/les-temps-futurs-du-kikongo-classique/`

---

**Version**: 1.0  
**Dernière mise à jour**: 2026-02-14  
**Auteur**: Correction automatique via GitHub Copilot
