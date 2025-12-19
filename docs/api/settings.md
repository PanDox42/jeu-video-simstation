# settings

**Extends:** `CanvasLayer`

Settings - Menu des paramètres du jeu

Gère les réglages audio (musique, effets sonores) et d'affichage (plein écran).

Synchronise les sliders avec les volumes des bus audio et gère le mode plein écran.


**Fichier:** `model\pause\settings.gd`

## Fonctions

### _ready()

Slider de volume pour la musique
Slider de volume pour les effets sonores
Bouton de basculement plein écran
Initialise les paramètres avec les valeurs actuelles
Charge les volumes audio et l'état du mode plein écran dans l'interface

### _on_musique_slider_value_changed(value: float) -> void

Ajuste le volume de la musique

**Paramètres:**

`value` : Valeur linéaire du volume (0.0 à 1.0)

### _on_effet_slider_value_changed(value: float) -> void

Ajuste le volume des effets sonores

**Paramètres:**

`value` : Valeur linéaire du volume (0.0 à 1.0)

### _on_check_button_toggled(toggled_on: bool) -> void

Bascule entre mode fenêtré et plein écran

**Paramètres:**

`toggled_on` : true pour plein écran, false pour fenêtré

### _on_reround_button_pressed() -> void

Ferme le menu des paramètres
