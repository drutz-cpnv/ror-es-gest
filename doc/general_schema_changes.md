# Justifications générales des modifications du schéma

## Principes directeurs

### 1. Respect des formes normales
- **1NF** : Toutes les valeurs sont atomiques, sans répétition d'attributs similaires.
- **2NF** : Tous les attributs non-clés dépendent de la totalité de la clé primaire.
- **3NF** : Aucun attribut non-clé ne dépend transitivement d'un autre attribut non-clé.

### 2. Clarté des relations
- Remplacement des références d'objets implicites par des clés étrangères explicites.
- Élimination des références bidirectionnelles redondantes.
- Utilisation de noms plus descriptifs pour les entités et les relations.

### 3. Cardinalités correctes
- Clarification de la relation "master" entre `Classes` et `People`.
- Explicitation de la relation many-to-many entre les étudiants et les classes via la table `enrollments`.
- Distinction claire entre différents types de relations (maître de classe vs. étudiant inscrit).

### 4. Optimisation pour l'implémentation
- Structure adaptée aux bases de données relationnelles.
- Facilitation des requêtes et des mises à jour.
- Réduction des risques d'incohérence des données.

## Changements principaux
1. **Élimination des références bidirectionnelles** pour éviter la redondance et les risques d'incohérence.
2. **Standardisation de la syntaxe** en utilisant des clés étrangères explicites plutôt que des références d'objets ou des annotations FK.
3. **Renommage de `students_classes` en `enrollments`** pour une meilleure sémantique.
4. **Enrichissement des entités de jointure** avec des attributs pertinents (comme la date d'inscription).
5. **Clarification des relations complexes** comme celle entre les enseignants, les étudiants et les classes. 