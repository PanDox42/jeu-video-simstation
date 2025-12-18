# game_manager

**Extends:** `Node`

GameManager - Contrôleur principal du jeu  Singleton qui gère l'état global du jeu, incluant la référence à la carte courante, le zoom de la caméra et le chemin du bâtiment en cours de placement.

**Fichier:** `controller\game_manager.gd`

## Variables

### current_map: Node

Référence vers la carte actuellement active dans la scène

### zoom_cam: Vector2

Niveau de zoom actuel de la caméra

### path_building: Node

Référence vers le nœud du bâtiment en cours de placement

## Fonctions

### set_current_map(map: Node)

Définit la carte actuellement active

**Paramètres:**

- `map`: Le nœud de la carte à définir comme carte courante

### get_current_map() -> Node

Récupère la carte actuellement active

**Retourne:** Le nœud de la carte courante

### set_current_zoom_cam(zoom_cam : Vector2)

Définit le niveau de zoom de la caméra

**Paramètres:**

- `zoom_cam`: Vecteur représentant le niveau de zoom (x, y)

### get_zoom_cam() -> Vector2

Récupère le niveau de zoom actuel de la caméra

**Retourne:** Le vecteur de zoom actuel

### open_search()

Ouvre l'interface de l'arbre de recherche Charge et affiche la scène de l'arbre de recherche dans le HUD

### load_scene(chemin_scene, name_node)

Charge dynamiquement une scène dans le HUD Si la scène existe déjà, bascule sa visibilité au lieu de la recharger

**Paramètres:**

- `chemin_scene`: Chemin vers le fichier .tscn à charger
- `name_node`: Nom à donner au nœud instancié
