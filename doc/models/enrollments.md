# Modèle Enrollments (anciennement students_classes)

## Modifications
- Renommage de `students_classes` en `enrollments` pour une meilleure sémantique
- Ajout des attributs `enrolled_at` et `notes` pour enrichir l'information sur l'inscription

## Justification
Le renommage apporte plus de clarté au modèle en reflétant mieux sa fonction (gestion des inscriptions) plutôt que sa structure technique (jointure entre étudiants et classes).

L'ajout des attributs temporels (`enrolled_at`) et descriptifs (`notes`) enrichit le modèle en permettant de stocker des informations importantes sur l'inscription, comme la date d'inscription et d'éventuelles remarques. Cette approche est conforme à la 2NF qui exige que tous les attributs soient pleinement dépendants de la clé primaire complète. 