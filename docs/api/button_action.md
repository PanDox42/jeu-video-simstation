# button_action

**Extends:** `TextureButton`

ButtonAction - Gestionnaire de navigation pour les boutons de menu

Gère l'ouverture et la fermeture des menus principaux du jeu (Shop, Pause, etc.)
Charge dynamiquement les scènes de menu dans le HUD et gère leur visibilité.

Permet aussi de bloquer/débloquer la caméra lors de l'ouverture des menus.


**Fichier:** `model\button\button_action.gd`

## Fonctions

### _on_pressed_shop() -> void

Ouvre le menu de la boutique
Charge la scène shop.tscn dans le HUD ou bascule sa visibilité

### _on_pressed_pause()

Ouvre le menu pause
Charge la scène pause.tscn dans le HUD ou bascule sa visibilité

### _physics_process(_delta)

Surveille les entrées clavier pour le menu pause
Détecte l'action "pause" (généralement Échap) pour ouvrir le menu

**Paramètres:**

`_delta` : Delta time (non utilisé)

### load_scene(scene_path, node_name)

Charge dynamiquement une scène dans le HUD ou bascule sa visibilité
Si la scène n'existe pas encore, elle est instanciée et ajoutée au HUD
Si elle existe déjà, sa visibilité est inversée

**Paramètres:**

`scene_path` : Chemin vers le fichier .tscn à charger

`node_name` : Nom à donner au nœud dans le HUD

### exit_button(node_name)

Ferme un menu spécifique en le rendant invisible
Utilisé pour forcer la fermeture d'un menu sans toggle

**Paramètres:**

`node_name` : Nom du nœud de menu à fermer
