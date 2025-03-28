# Modèle Classes

## Modifications
- Remplacement des références d'objets (`Moment moment`, `Room room`, etc.) par des clés étrangères explicites (`integer moment_id`, `integer room_id`, etc.)
- Clarification de la relation maître de classe avec `Person master`
- Suppression de la référence bidirectionnelle `People[] students`

## Justification
Ces modifications respectent mieux la 3NF en rendant explicites les dépendances fonctionnelles par l'utilisation des clés étrangères. Les types d'objets implicites dans l'ancien modèle pouvaient causer des ambiguïtés. 

La relation many-to-many avec les étudiants est maintenant gérée exclusivement via la table de jointure `enrollments` (anciennement `students_classes`), ce qui améliore la cohérence et évite la redondance des données. 