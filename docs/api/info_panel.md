# info_panel

**Extends:** `PanelContainer`

InfoPanel - Panneau d'informations des bâtiments

Affiche les détails d'un bâtiment cliqué : nom, santé, bonheur, description.

Pour le laboratoire, affiche aussi un bouton pour accéder à l'arbre de recherche.

Se positionne automatiquement à droite de l'écran.


**Fichier:** `model\hud\info_panel.gd`

## Variables

### boxContainer

Police Minecraft pour le style rétro
Conteneur vertical pour organiser les éléments

### close_button

Bouton pour fermer le panneau

### name_label

Label affichant le nom du bâtiment

### hapiness_label

Label affichant le bonheur apporté

### description_label

Label affichant la description

### search_button

Bouton pour ouvrir l'arbre de recherche (visible uniquement pour le labo)

## Fonctions

### _ready()

Initialise le panneau et ses éléments visuels

### display_infos(id_batiment: int)

Affiche les informations d'un bâtiment

**Paramètres:**

`id_batiment` : ID du bâtiment à afficher

### hide_infos()

Cache le panneau d'informations

### open_search()

Ouvre l'interface de l'arbre de recherche

### styliser_labels()

Applique un style personnalisé aux labels
