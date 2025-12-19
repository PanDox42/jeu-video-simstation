extends TextureRect

@onready var label_already_used = $RLabelAlreadyUsed
@onready var line_edit_name = $LineEditName

func _on_button_continue_pressed() -> void:
	# 1. On récupère le nom et on enlève les espaces inutiles
	var station_name = line_edit_name.text.strip_edges()

	# 2. Vérification : Nom vide ?
	if station_name == "":
		label_already_used.visible = true
		return 

	# 3. VÉRIFICATION DU DOUBLON
	var path = "user://" + station_name + ".json"
	if FileAccess.file_exists(path):
		label_already_used.visible = true
		return
	else:
		label_already_used.visible = false # On cache le message si c'est bon

	# 4. TOUT EST OK -> ON ENREGISTRE LES DONNÉES
	GlobalScript.set_name_station(station_name)

	# 5. ON INITIALISE LE MANAGER ET ON CHANGE DE SCÈNE
	GameManager.setup_new_game(station_name)
	get_tree().change_scene_to_file("res://view/play.tscn")
		

func _on_button_exit_pressed() -> void:
	queue_free()
