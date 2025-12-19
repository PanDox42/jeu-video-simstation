extends CanvasLayer

const MENU_OPTIONS_SCENE = preload("res://view/settings.tscn")
const CREDITS_SCENE = preload("res://view/credits.tscn")
const NEW_GAME_CREATION = preload("res://view/new_game_creation.tscn")
var menu_instance = null

func _ready():
	if not GameManager.has_save_files():
		$PanelGameMenu/TButtonContinue.disabled = true
		$PanelGameMenu/TButtonContinue.modulate.a = 0.5
	else:
		$PanelGameMenu/TButtonContinue.disabled = false
		$PanelGameMenu/TButtonContinue.modulate.a = 1.0

func _on_btn_new_game_pressed() -> void:
	var new_game_config = NEW_GAME_CREATION.instantiate()
	add_child(new_game_config)
	
	new_game_config.get_node("ButtonContinue").pressed.connect(_on_continue_new_game_clicked)

func _on_continue_new_game_clicked():
	var config_ui = get_node("NewGameCreation") 
	
	GameManager.setup_new_game() 
	
	if config_ui:
		var station_name = config_ui.get_node("LineEditName").text
		if station_name != "":
			GlobalScript.set_name_station(station_name)
	
	# 2. On change de scène une fois que les données sont propres
	get_tree().change_scene_to_file("res://view/play.tscn")
	
func _on_t_button_continue_pressed():
	get_tree().change_scene_to_file("res://view/saved_game.tscn")
	
func _on_btn_options_pressed() -> void:
	if menu_instance == null:
		menu_instance = MENU_OPTIONS_SCENE.instantiate()
		get_parent().add_child(menu_instance) 
	else:
		var is_visibles = menu_instance.visible
		menu_instance.visible = not is_visibles

func _on_btn_quitter_pressed() -> void:
	get_tree().quit()


func _on_btn_credits_pressed() -> void:
	if menu_instance == null:
		menu_instance = CREDITS_SCENE.instantiate()
		get_parent().add_child(menu_instance) 
	else:
		var is_visibles = menu_instance.visible
		menu_instance.visible = not is_visibles

func _on_btn_tuto_pressed():
	var tuto_scene = load("res://View/tuto.tscn")
	var tuto_instance = tuto_scene.instantiate()
	
	add_child(tuto_instance)
	
