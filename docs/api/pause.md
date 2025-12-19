# pause

**Extends:** `CanvasLayer`

Pause - Menu pause du jeu

Gère l'affichage et les interactions du menu pause.

Met le jeu en pause et permet de reprendre, accéder aux options ou retourner au menu principal.


**Fichier:** `model\pause\pause.gd`

## Fonctions

### _ready()

Initialise le menu pause
Configure le mode de traitement pour fonctionner même quand le jeu est en pause

### _on_resume_button_pressed() -> void

Reprend le jeu
Cache le menu pause et reprend l'exécution du jeu

### _on_option_button_pressed() -> void

Ouvre le menu des options
Charge et affiche le menu settings dans le HUD

### _on_menu_button_pressed() -> void

Retourne au menu principal
Reprend le jeu, nettoie le menu pause et charge la scène du menu principal
