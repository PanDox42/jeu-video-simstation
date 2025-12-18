extends CanvasLayer

func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	visible = true
	get_tree().paused = true  

func _on_resume_button_pressed() -> void:
	visible = false
	get_tree().paused = false
	
	var play_scene = get_tree().current_scene
	var hud = play_scene.get_node("hud")
	if hud.has_node("Pause"):
		var pause_menu = hud.get_node("Pause")
		pause_menu.queue_free() 

func _on_option_button_pressed() -> void:
	var options_scene = load("res://View/settings.tscn")
	var play_scene = get_tree().current_scene
	var hud = play_scene.get_node("hud")

	if not hud.has_node("Settings"):
		var instance = options_scene.instantiate()
		instance.name = "Settings"
		hud.add_child(instance)
	else:
		var node = hud.get_node("Settings")
		node.visible = !node.visible


func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	
	var play_scene = get_tree().current_scene	
	var hud = play_scene.get_node("hud")
	if hud.has_node("Pause"):
		var pause_menu = hud.get_node("Pause")
		pause_menu.queue_free() 
		
	get_tree().change_scene_to_file("res://View/main_menu.tscn")
	
	
