extends CanvasLayer

const MENU_OPTIONS_SCENE = preload("res://View/options.tscn")
const CREDITS_SCENE = preload("res://View/credits.tscn")
var menu_instance = null

func _on_btn_jouer_pressed() -> void:
	get_tree().change_scene_to_file("res://View/play.tscn")

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
	var tuto_scene = load("res://View/Tuto.tscn")
	var tuto_instance = tuto_scene.instantiate()
	
	add_child(tuto_instance)
