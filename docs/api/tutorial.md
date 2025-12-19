# tutorial

**Extends:** `CanvasLayer`

Tuto - Tutoriel interactif du jeu

Affiche un tutoriel pas à pas avec des captures d'écran et des descriptions.

Permet au joueur de naviguer entre les différentes étapes du tutoriel.


**Fichier:** `model\main_menu\tutorial.gd`

## Variables

### tuto_data

Données du tutoriel sous forme de liste [Chemin image, Description]
Chaque élément représente une étape du tutoriel

### index_actuel

Index de l'étape actuellement affichée

## Fonctions

### _ready()

TextureRect affichant l'image de l'étape
Label affichant la description de l'étape
Label du bouton suivant (change en "Terminer" à la dernière étape)
Initialise le tutoriel à la première étape

### afficher_etape(index)

Affiche une étape spécifique du tutoriel
Met à jour l'image, le texte et le libellé du bouton

**Paramètres:**

`index` : Index de l'étape à afficher

### _on_next_button_pressed()

Passe à l'étape suivante ou ferme le tutoriel
Appelé quand le bouton "Suivant" ou "Terminer" est pressé

### _on_close_button_pressed()

Ferme le tutoriel
