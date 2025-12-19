## Tuto - Tutoriel interactif du jeu
##
## Affiche un tutoriel pas à pas avec des captures d'écran et des descriptions.
## Permet au joueur de naviguer entre les différentes étapes du tutoriel.
extends CanvasLayer

## Données du tutoriel sous forme de liste [Chemin image, Description]
## Chaque élément représente une étape du tutoriel
var tuto_data = [
	["res://assets/tuto/CaptureMainScreen.PNG", "Bienvenue sur SimStation ! Vous allez devoir gérer votre base en Antarctique."],
	["res://assets/tuto/CapturePlayScreen.PNG", "Voici votre zone de construction. Ici, vous pouvez ajouter des bâtiments en les faisant glisser depuis la gauche."],
	["res://assets/tuto/CaptureStats.PNG", "Analysez vos graphiques pour anticiper les crises de santé ou de moral."],
	["res://assets/tuto/CaptureStatsDescend.PNG", "Vos stats descendent trop vite ?\nAjoutez une chaufferie pour chauffer vos bâtiments !"],
	["res://assets/tuto/CaptureStatsStable.PNG", "Et voilà ! Avec deux chaufferies, la station arrive amplement à subvenir à ses besoins en chaleur !"],
	["res://assets/tuto/CaptureStatsHopital.PNG", "Mais vos habitants doivent aussi se soigner ! Construisez un hôpital et il augmentera votre santé globale !"],
	["res://assets/tuto/CaptureCatastrophe.PNG", "Mais attention, il se peut que vous rencontriez des catastrophes naturelles qui feront descendre vos stats."],
	["res://assets/tuto/CaptureDescription.PNG", "Quand vous cliquez sur un bâtiment, vous verrez sa description, sa santé, et le bonheur qu'il confère aux habitants."],
	["res://assets/tuto/CaptureRechercheBouton.PNG", "Pour accéder à l'arbre de recherche, il faut placer un laboratoire et cliquer sur le bouton Recherche qui est dans sa description."],
	["res://assets/tuto/CaptureRechercheScreen.PNG", "L'arbre de recherche vous permet de débloquer des technologies et des bâtiments ; ce sera votre unique source de revenus."],
	["res://assets/tuto/CaptureShop.PNG", "La boutique vous permet d'acheter de nouveaux bâtiments (à condition qu'ils aient été débloqués par les recherches)."],
]

## Index de l'étape actuellement affichée
var index_actuel = 0

## TextureRect affichant l'image de l'étape
@onready var display_image = $TRectDisplayImage

## Label affichant la description de l'étape
@onready var description_label = $PanelBottom/LabelDescription

## Label du bouton suivant (change en "Terminer" à la dernière étape)
@onready var label_next = $PanelBottom/ButtonNext/LabelNext

## Initialise le tutoriel à la première étape
func _ready():
	afficher_etape(0)

## Affiche une étape spécifique du tutoriel
## Met à jour l'image, le texte et le libellé du bouton
## @param index: Index de l'étape à afficher
func afficher_etape(index):
	index_actuel = index
	var data = tuto_data[index]
	
	# Mise à jour visuelle
	display_image.texture = load(data[0])
	description_label.text = data[1]
	
	# Si c'est la dernière image, on change le texte du bouton
	if index == tuto_data.size() - 1:
		label_next.text = "Terminer"
	else:
		label_next.text = "Suivant"

## Passe à l'étape suivante ou ferme le tutoriel
## Appelé quand le bouton "Suivant" ou "Terminer" est pressé
func _on_next_button_pressed():
	if index_actuel < tuto_data.size() - 1:
		afficher_etape(index_actuel + 1)
	else:
		# Fin du tuto
		_on_close_button_pressed()

## Ferme le tutoriel
func _on_close_button_pressed():
	queue_free()
