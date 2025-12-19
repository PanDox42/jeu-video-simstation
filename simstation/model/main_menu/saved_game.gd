extends CanvasLayer

@export var slot_scene: PackedScene # Glisse SaveSlot.tscn ici dans l'inspecteur
@onready var list_container = $PanelGameMenu/ScrollContainer/VBoxContainer

func _ready():
	refresh_save_list()

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

func create_slot_button(file_name):
	# Lire le fichier pour extraire les infos (argent, date)
	var path = "user://" + file_name
	var file = FileAccess.open(path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	
	# Instancier le bouton
	var new_slot = slot_scene.instantiate()
	list_container.add_child(new_slot)
	
	# Configurer le bouton avec les infos du JSON
	new_slot.setup(file_name.replace(".json", ""), data["money"], data["save_date"])
	
	# Connecter le clic
	new_slot.slot_selected.connect(_on_slot_clicked)

func _on_slot_clicked(file_name):
	GameManager.load_game(file_name)
	get_tree().change_scene_to_file("res://view/play.tscn")

func _on_t_button_retour_pressed():
	get_tree().change_scene_to_file("res://view/main_menu.tscn")
