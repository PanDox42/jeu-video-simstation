# map

**Extends:** `Node2D`

Map - Gestionnaire de la carte de jeu

Gère le placement des bâtiments sur la carte et les interactions avec les bâtiments placés.

Vérifie les collisions entre bâtiments et détecte les clics pour afficher les informations.


**Fichier:** `model\map\map.gd`

## Fonctions

### _ready()

Nœud contenant tous les bâtiments placés sur la carte
Ajoute ce nœud au groupe "Map" pour le rendre détectable

### spawn_saved_buildings()

### _create_building_instance(id: int, data: Dictionary)

### add_temp_building(node: Sprite2D)

Ajoute temporairement un bâtiment à la carte (mode ghost/preview)

**Paramètres:**

`node` : Sprite2D du bâtiment à ajouter temporairement

### validate_building(node: Sprite2D)

Valide le placement final d'un bâtiment
Appelé quand le joueur confirme le placement

**Paramètres:**

`node` : Sprite2D du bâtiment à valider

### is_placable(ghost_building: Sprite2D) -> bool

Vérifie si un bâtiment peut être placé sans collision
Teste les intersections avec tous les bâtiments existants

**Paramètres:**

`ghost_building` : Sprite2D du bâtiment en cours de placement

**Retourne:** true si le placement est valide, false sinon

### _unhandled_input(event)

Détecte les clics sur les bâtiments et émet le signal d'information
Appelé automatiquement par le système d'input de Godot

**Paramètres:**

`event` : Événement d'input (clic souris)

### get_building_under_mouse() -> Sprite2D

Trouve le bâtiment situé sous le curseur de la souris
Parcourt les bâtiments en ordre inverse (du plus récent au plus ancien)

**Retourne:** Sprite2D du bâtiment sous la souris, ou null si aucun

### get_global_rect_of(node: Sprite2D) -> Rect2

Calcule le rectangle global (bounding box) d'un sprite
Utilisé pour les calculs de collision et de sélection

**Paramètres:**

`node` : Sprite2D dont on veut calculer la zone

**Retourne:** Rect2 représentant la zone globale du sprite
