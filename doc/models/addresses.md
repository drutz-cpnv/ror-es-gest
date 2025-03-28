# Modèle Addresses

## Modifications
- Suppression de la référence bidirectionnelle `Person[] people`

## Justification
La suppression de la référence inverse aux personnes respecte mieux la 3NF en évitant la redondance d'informations. La relation entre adresses et personnes est déjà définie par la clé étrangère `address_id` dans le modèle `People`. Garder cette référence bidirectionnelle pourrait créer des incohérences lors des mises à jour. 