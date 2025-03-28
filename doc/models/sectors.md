# Modèle Sectors

## Modifications
- Suppression des références bidirectionnelles `Class[] classes` et `PromotionAssert[] promotion_asserts`

## Justification
La suppression des références bidirectionnelles respecte mieux la 3NF en évitant la redondance d'informations. Les relations avec les classes et les assertions de promotion sont déjà définies par les clés étrangères dans les modèles correspondants (`sector_id` dans `Classes` et `PromotionAsserts`).

Cette approche simplifie le modèle et réduit les risques d'incohérence des données lors des mises à jour, tout en maintenant l'intégrité référentielle via les clés étrangères. 