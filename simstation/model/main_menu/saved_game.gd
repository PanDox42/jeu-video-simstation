extends CanvasLayer

## Scène préchargée pour les slots de sauvegarde
@export var slot_scene: PackedScene # Glisse save_slot.tscn ici dans l'inspecteur

## Conteneur vertical pour afficher la liste des sauvegardes
@onready var list_container = $TRectGameMenu/ScrollContainer/VBoxContainer

## Initialise l'interface et charge la liste des sauvegardes
func _ready():
	refresh_save_list()

## Rafraîchit la liste des sauvegardes disponibles
## Scanne le dossier user:// et crée un bouton pour chaque fichier .json
func refresh_save_list():
	# Nettoyer la liste existante
	for child in list_container.get_children():
		child.queue_free()

	# Scanner le dossier user://
	var dir = DirAccess.open("user://")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if file_name.ends_with(".json"):
				create_slot_button(file_name)
			file_name = dir.get_next()

## Crée un bouton de slot pour une sauvegarde
## @param file_name: Nom du fichier de sauvegarde (avec .json)
func create_slot_button(file_name):
	# Lire le fichier pour extraire les infos (argent, date)
	var path = "user://%s" % file_name
	var file = FileAccess.open(path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	
	# Instancier le bouton
	var new_slot = slot_scene.instantiate()
	list_container.add_child(new_slot)
	
	# Configurer le bouton avec les infos du JSON
	new_slot.setup(file_name.replace(".json", ""), data["money"], data["save_date"])
	
	# Connecter le clic
	new_slot.slot_selected.connect(_on_slot_clicked)

## Appelé lors du clic sur un slot de sauvegarde
## @param file_name: Nom du fichier à charger (sans .json)
func _on_slot_clicked(file_name):
	GameManager.load_game(file_name)
	get_tree().change_scene_to_file("res://view/play.tscn")

## Ferme l'interface et retourne au menu principal
func _on_t_button_retour_pressed():
	queue_free()
