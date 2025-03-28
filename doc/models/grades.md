# Modèle Grades

## Modifications
- Remplacement des références d'objets (`Examination examination`, `Person student`) par des clés étrangères explicites (`integer examination_id`, `integer student_id`)

## Justification
Le remplacement des références d'objets par des clés étrangères explicites respecte mieux la 3NF en rendant les dépendances fonctionnelles plus claires et explicites. 

Cette approche permet une meilleure compréhension du modèle de données, car elle montre directement les relations sans ambiguïté. Elle facilite également la mise en œuvre dans une base de données relationnelle où les relations sont définies par des clés étrangères plutôt que par des références d'objets. 