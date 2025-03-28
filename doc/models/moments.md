# Modèle Moments

## Modifications
- Suppression des références bidirectionnelles `Class[] classes`, `Course[] courses` et `PromotionAssert[] promotion_asserts`

## Justification
La suppression des références bidirectionnelles est conforme à la 3NF en éliminant la redondance d'informations. Les relations avec les classes, les cours et les assertions de promotion sont déjà définies par les clés étrangères dans les modèles correspondants (`moment_id` dans `Classes`, `Courses` et `PromotionAsserts`).

Ce changement simplifie le modèle tout en maintenant l'intégrité référentielle via les clés étrangères, ce qui réduit également les risques d'incohérence lors des mises à jour de données. 