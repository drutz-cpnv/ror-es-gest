# Modèle Promotion Asserts

## Modifications
- Remplacement des références annotées FK (`Moment moment FK`, `Sector sector FK`) par des clés étrangères explicites (`integer moment_id`, `integer sector_id`)

## Justification
Le remplacement des références par des clés étrangères explicites respecte mieux la 3NF en rendant les dépendances fonctionnelles plus claires et cohérentes avec le reste du modèle. 

Cette approche unifie également la syntaxe utilisée dans le schéma, rendant toutes les relations cohérentes et explicites, ce qui facilite la compréhension du modèle et sa mise en œuvre dans une base de données relationnelle. 