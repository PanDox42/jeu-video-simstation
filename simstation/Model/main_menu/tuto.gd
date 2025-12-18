extends CanvasLayer

# Liste des données : [Chemin Image, Texte de description]
var tuto_data = [
	["res://assets/tuto/CaptureMainScreen.PNG", "Bienvenue sur SimStation ! Gérez votre base antarctique."],
	["res://assets/tuto/CapturePlayScreen.PNG", "Voici votre zone de construction. Surveillez vos stats en haut."],
	["res://assets/tuto/CaptureStats.PNG", "Analysez vos graphiques pour anticiper les crises de santé ou de moral."],
	["res://assets/tuto/CaptureStatsDescend.PNG", "Vos stats descendent trop vite ?\nAjoutez une chaufferie pour chauffer vos batiments !!!"],
	["res://assets/tuto/CaptureStatsStable.PNG", "Et voilà !!! Avec 2 chaufferie, la station arrive amplement à subvenir à ces besoins en chaleur !"],
	["res://assets/tuto/CaptureStatsHopital.PNG", "Mais vos habitants doivent aussi se soigner ! Construisez un hopital et celui-ci augmentera votre santé globale !"],
	["res://assets/tuto/CaptureShop.PNG", "La boutique vous permet d'acheter de nouveaux bâtiments essentiels."],
	["res://assets/tuto/CaptureRechercheScreen.PNG", "L'arbre de recherche débloque des technologies de survie avancées."],
]

var index_actuel = 0

@onready var display_image = $TRectDisplayImage
@onready var description_label = $PanelBottom/LabelDescription
@onready var label_next = $PanelBottom/ButtonNext/LabelNext

func _ready():
	afficher_etape(0)

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

func _on_next_button_pressed():
	if index_actuel < tuto_data.size() - 1:
		afficher_etape(index_actuel + 1)
	else:
		# Fin du tuto
		_on_close_button_pressed()

func _on_close_button_pressed():
	queue_free()
