# camera_2d

**Extends:** `Camera2D`

Camera2D - Caméra de jeu avec contrôles drag et zoom

Gère les contrôles de la caméra : déplacement par clic-glisser et zoom à la molette.

Limite la caméra aux frontières de la carte pour éviter de sortir de la zone jouable.

S'active/désactive selon l'état global de la caméra.


**Fichier:** `model\hud\camera\camera_2d.gd`

## Variables

### dragging: bool

Indique si on est en train de faire glisser la caméra

## Fonctions

### _ready() -> void

Initialise les limites de la caméra

### _unhandled_input(event: InputEvent) -> void

Gère les entrées de la caméra (drag et zoom)

**Paramètres:**

`event` : Événement d'input

### recentrer_camera() -> void

Recentre la caméra à l'origine
