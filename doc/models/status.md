# Modèle Status

## Modifications
- Suppression de la référence bidirectionnelle `Person[] people`

## Justification
La suppression de la référence inverse aux personnes est conforme à la 3NF en évitant la redondance d'informations. La relation entre statuts et personnes est déjà définie par la clé étrangère `status_id` dans le modèle `People`. Maintenir cette référence bidirectionnelle aurait pu créer des incohérences lors des mises à jour de données. 