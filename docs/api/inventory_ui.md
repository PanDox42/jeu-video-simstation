# inventory_ui

**Extends:** `Control`

InventaireUI - Interface graphique de l'inventaire

Affiche dynamiquement l'inventaire des bâtiments dans une grille.

Génère une carte pour chaque type de bâtiment débloqué avec son image et sa quantité.

Grise automatiquement les bâtiments en quantité zéro.

Attache le script de drag & drop à chaque icône pour permettre le placement.


**Fichier:** `model\hud\inventory\inventory_ui.gd`

## Fonctions

### _ready()

Initialise l'inventaire et se connecte aux signaux

### display_inventory()

Régénère complètement l'inventaire
Efface tous les éléments et les recrée depuis l'inventaire global

### create_building_button(building_name: String, quantite: int)

Crée une carte de bâtiment dans l'inventaire
Génère un conteneur avec l'icône et le label de quantité
Attache le script de drag & drop à l'icône
Grise l'icône si la quantité est zéro

**Paramètres:**

`building_name` : Nom interne du bâtiment

`quantite` : Quantité disponible

### _on_batiment_changed(building_name, new_val)

Met à jour la quantité affichée et la couleur d'un bâtiment spécifique
Utilisé pour éviter de régénérer tout l'inventaire quand une quantité change

**Paramètres:**

`building_name` : Nom du bâtiment à mettre à jour

`new_val` : Nouvelle quantité
