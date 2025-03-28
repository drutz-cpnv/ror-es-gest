# Modèle Courses

## Modifications
- Remplacement des références d'objets (`Subject subject`, `Class class`, `Moment moment`) par des clés étrangères explicites (`integer subject_id`, `integer class_id`, `integer moment_id`)
- Suppression de la référence bidirectionnelle `Examination[] examinations`

## Justification
Le remplacement des références d'objets par des clés étrangères explicites apporte plus de clarté et respecte mieux la 3NF en rendant explicites les dépendances fonctionnelles. 

La suppression de la référence bidirectionnelle aux examens élimine la redondance d'informations, car la relation est déjà définie par la clé étrangère `course_id` dans le modèle `Examinations`. Cette approche simplifie le modèle et réduit les risques d'incohérence lors des mises à jour, tout en préservant l'intégrité référentielle. 