# Modèle Rooms

## Modifications
- Aucune modification majeure, le modèle était déjà conforme aux formes normales

## Justification
Le modèle `Rooms` était déjà conforme aux formes normales jusqu'à la 3NF :
- 1NF : Toutes les valeurs sont atomiques
- 2NF : Tous les attributs sont dépendants de la clé primaire complète
- 3NF : Aucune dépendance transitive n'existe

Le modèle conserve sa structure simple avec un identifiant unique (`id`) et un nom unique (`name UK`), ce qui est approprié pour représenter les salles dans le système. 