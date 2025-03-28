# Modèle Examinations

## Modifications
- Remplacement de la référence d'objet `Course course` par une clé étrangère explicite `integer course_id`
- Suppression de la référence bidirectionnelle `Grade[] grades`

## Justification
Le remplacement de la référence d'objet par une clé étrangère explicite respecte mieux la 3NF en rendant la dépendance fonctionnelle plus claire et explicite.

La suppression de la référence bidirectionnelle aux notes élimine la redondance d'informations, car la relation est déjà définie par la clé étrangère `examination_id` dans le modèle `Grades`. Cette approche simplifie le modèle et minimise les risques d'incohérence lors des mises à jour de données, tout en maintenant l'intégrité référentielle via les clés étrangères. 