# drag_building

**Extends:** `TextureRect`

DragBuilding - Système de placement de bâtiments par glisser-déposer

Gère l'interface utilisateur pour le placement de bâtiments via drag & drop.

Permet de glisser un bâtiment de l'inventaire vers la carte avec :
- Grille visuelle temporaire pour l'alignement
- Système d'aimantation (snapping) sur grille 64x64
- Feedback visuel (vert = OK, rouge = collision)
- Validation (clic gauche) ou annulation (clic droit)

**Fichier:** `model\hud\inventory\drag_building.gd`

## Variables

### building_instance: Sprite2D

Son joué quand on prend un bâtiment
Son joué lors d'un placement invalide
Son joué lors d'un placement réussi
Son joué quand pas assez de ressources
Taille d'une cellule de la grille en pixels
Instance temporaire du bâtiment fantôme suivant la souris

### map_ref

Référence à la carte de jeu

### dragging: bool

Indique si on est en mode placement

### grid_visual_instance: Node2D

Instance de la grille visuelle temporaire

### cell_size

GridDrawer - Classe interne pour dessiner la grille temporaire
Taille d'une cellule

### grid_color

Couleur de la grille

### draw_area

Zone de dessin

## Fonctions

### _ready()

Initialise le curseur

### _get_drag_data(_at_position)

### _gui_input(event)

Gère le clic sur l'icône de bâtiment dans l'inventaire

**Paramètres:**

`event` : Événement d'input

### _unhandled_input(event)

Gère les clics pendant le placement (validation/annulation)

**Paramètres:**

`event` : Événement d'input

### _process(_delta)

Met à jour la position du bâtiment fantôme selon la souris

**Paramètres:**

`_delta` : Delta time

### start_dragging()

Démarre le mode placement : crée le fantôme et la grille

### place_building()

Valide le placement si l'emplacement est libre

### cancel_placement()

Annule le placement et rembourse le bâtiment

### remove_grid()

Supprime la grille visuelle

### update_visual_feedback()

Met à jour la couleur du fantôme (vert OK / rouge collision)

### _draw()

Dessine les lignes de la grille
