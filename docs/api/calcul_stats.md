# calcul_stats

**Extends:** `Node2D`

CalculStats - Système de calcul des statistiques de la station

Gère tous les calculs de statistiques round par round pour SimStation.

Calcule l'impact de la température, des bâtiments, des catastrophes
sur la santé, le bonheur et l'efficacité de la population.


Ce système utilise des constantes d'équilibrage pour créer une difficulté progressive
et garantir que le joueur doit construire des infrastructures pour survivre.


**Fichier:** `model\global\calcul_stats.gd`

## Fonctions

### _ready() -> void

Puissance de chauffage apportée par chaque chaufferie
Vitesse de refroidissement des bâtiments sans chauffage par round
Initialisation des statistiques au démarrage

### next_round() -> void

Fonction principale appelée à chaque nouveau round
Enchaîne les calculs dans l'ordre : saisons, catastrophes, stats, signaux

### _add_stats_new_building(building_type_name)

Applique un boost immédiat de bonheur lors de la construction d'un bâtiment
Appelé par le système de construction

**Paramètres:**

`building_type_name` : Type du bâtiment construit (ex: "dormitory")

### update_derived_stats() -> void

Recalcule les statistiques dérivées à partir de santé et bonheur
Formule : Efficacité = (Santé * 0.6) + (Bonheur * 0.4)
Met à jour le Global et la population avec lerp

### _calculate_season_and_weather() -> void

Calcule et applique la saison suivante avec sa température
Cycle de 4 saisons : Été (0) -> Automne (1) -> Hiver (2) -> Printemps (3)
- Été: -25°C à -40°C
- Automne: -40°C à -55°C
- Hiver: -60°C à -80°C (le plus dangereux)
- Printemps: -45°C à -60°C

### _apply_changes_turn() -> void

Applique tous les changements statistiques du round
Séquence de calcul :
1. Comptage des bâtiments spéciaux (chaufferies, hôpitaux)
2. Simulation thermique (chauffage/refroidissement des bâtiments)
3. Calcul impact température sur santé
4. Calcul impact bâtiments sur bonheur
5. Application finale des deltas

### _gerer_catastrophes() -> void

Vérifie et applique une éventuelle catastrophe aléatoire
Utilise le système Catastrophes.verify_disaster()
Applique directement les malus de santé et bonheur si une catastrophe se déclenche
