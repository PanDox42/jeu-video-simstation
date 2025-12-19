# saved_game

**Extends:** `CanvasLayer`

**Fichier:** `model\main_menu\saved_game.gd`

## Fonctions

### _ready()

Scène préchargée pour les slots de sauvegarde
Conteneur vertical pour afficher la liste des sauvegardes
Initialise l'interface et charge la liste des sauvegardes

### refresh_save_list()

Rafraîchit la liste des sauvegardes disponibles
Scanne le dossier user:// et crée un bouton pour chaque fichier .json

### create_slot_button(file_name)

Crée un bouton de slot pour une sauvegarde

**Paramètres:**

`file_name` : Nom du fichier de sauvegarde (avec .json)

### _on_slot_clicked(file_name)

Appelé lors du clic sur un slot de sauvegarde

**Paramètres:**

`file_name` : Nom du fichier à charger (sans .json)

### _on_t_button_retour_pressed()

Ferme l'interface et retourne au menu principal
