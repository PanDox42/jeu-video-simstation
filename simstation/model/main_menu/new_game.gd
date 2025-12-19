extends TextureRect

## Label affichant le message d'erreur si le nom est déjà utilisé
@onready var label_already_used = $RLabelAlreadyUsed

## Champ de saisie pour le nom de la station
@onready var line_edit_name = $LineEditName

## Valide et lance une nouvelle partie
## Vérifie que le nom n'est pas vide et qu'aucune sauvegarde n'existe avec ce nom
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
		

## Ferme la fenêtre de création de partie
func _on_button_exit_pressed() -> void:
	queue_free()
