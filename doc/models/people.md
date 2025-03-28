# Modèle People

## Modifications
- Remplacement des références d'objets (`Status status`, `Address address`) par des clés étrangères explicites (`integer status_id`, `integer address_id`)
- Suppression de la référence bidirectionnelle `Class[] classes`
- Ajout d'une relation many-to-many explicite avec les classes via `attends`

## Justification
Ces modifications apportent plus de clarté aux relations en rendant explicites les clés étrangères, ce qui est conforme à la 3NF. La suppression de la référence bidirectionnelle aux classes évite la redondance de données et les risques d'incohérence.

L'association many-to-many avec les classes est maintenant correctement modélisée par une relation explicite et par la table de jointure `enrollments`. Cela permet de distinguer clairement entre le rôle d'un enseignant qui est "maître" d'une classe et les étudiants qui "assistent" aux classes. 