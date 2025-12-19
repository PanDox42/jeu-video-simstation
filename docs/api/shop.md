# shop

**Extends:** `CanvasLayer`

Shop - Interface d'achat des bâtiments

Affiche la boutique avec tous les bâtiments débloqués disponibles à l'achat.

Génère dynamiquement l'interface pour chaque bâtiment avec son image, prix et description.

Se recharge automatiquement quand un nouveau bâtiment est débloqué.


**Fichier:** `model\shop\shop.gd`

## Fonctions

### _ready()

Initialise la boutique et se connecte au signal de déverrouillage

### load_buildings()

Recharge tous les bâtiments disponibles dans la boutique
Efface l'ancien contenu et régénère les cartes pour chaque bâtiment débloqué

### initialize(building_name: String)

Crée l'interface UI pour un bâtiment dans la boutique
Génère deux colonnes : image/prix/bouton à gauche, description/stats à droite

**Paramètres:**

`building_name` : Nom interne du bâtiment (ex: "dormitory")

### _on_exit_button_pressed() -> void

Ferme la boutique en la rendant invisible

### buy_building(building_name)

Ouvre la fenêtre de confirmation d'achat pour un bâtiment

**Paramètres:**

`building_name` : Nom du bâtiment à acheter
