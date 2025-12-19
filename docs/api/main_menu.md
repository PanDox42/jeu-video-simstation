# main_menu

**Extends:** `CanvasLayer`

MainMenu - Menu principal du jeu

Gère la navigation du menu principal avec les options :
Jouer, Options, Crédits, Tutoriel et Quitter.

Charge dynamiquement les sous-menus sans les dupliquer.


**Fichier:** `model\main_menu\main_menu.gd`

## Variables

### menu_instance

Scène du menu options préchargée
Scène des crédits préchargée
Instance actuelle du menu secondaire (options ou crédits)

## Fonctions

### _on_btn_jouer_pressed() -> void

Lance la partie
Charge la scène de jeu principale

### _on_btn_options_pressed() -> void

Ouvre le menu des options
Instancie ou bascule la visibilité du menu settings

### _on_btn_quitter_pressed() -> void

Quitte le jeu

### _on_btn_credits_pressed() -> void

Ouvre le menu des crédits
Instancie ou bascule la visibilité de l'écran des crédits

### _on_btn_tuto_pressed()

Ouvre le tutoriel
Charge et affiche l'écran de tutoriel interactif
