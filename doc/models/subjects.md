# Modèle Subjects

## Modifications
- Suppression de la référence bidirectionnelle `Cours[] courses`

## Justification
La suppression de la référence bidirectionnelle aux cours respecte la 3NF en éliminant la redondance d'informations. La relation entre les sujets et les cours est déjà définie par la clé étrangère `subject_id` dans le modèle `Courses`.

Cette modification simplifie le modèle et minimise les risques d'incohérence des données lors des mises à jour, tout en maintenant l'intégrité référentielle via les clés étrangères. 