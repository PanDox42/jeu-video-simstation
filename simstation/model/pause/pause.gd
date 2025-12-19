## Pause - Menu pause du jeu
##
## Gère l'affichage et les interactions du menu pause.
## Met le jeu en pause et permet de reprendre, accéder aux options ou retourner au menu principal.
extends CanvasLayer

## Initialise le menu pause
## Configure le mode de traitement pour fonctionner même quand le jeu est en pause
func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	visible = true
	get_tree().paused = true  

## Reprend le jeu
## Cache le menu pause et reprend l'exécution du jeu
func _on_resume_button_pressed() -> void:
	visible = false
	get_tree().paused = false
	
	var play_scene = get_tree().current_scene
	var hud = play_scene.get_node("hud")
	if hud.has_node("Pause"):
		var pause_menu = hud.get_node("Pause")
		pause_menu.queue_free() 

## Ouvre le menu des options
## Charge et affiche le menu settings dans le HUD
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


## Retourne au menu principal
## Reprend le jeu, nettoie le menu pause et charge la scène du menu principal
func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	
	var play_scene = get_tree().current_scene
	var hud = play_scene.get_node("hud")
	if hud.has_node("Pause"):
		var pause_menu = hud.get_node("Pause")
		pause_menu.queue_free() 
	
	GameManager.save_game(GlobalScript.get_name_station())
	get_tree().change_scene_to_file("res://View/main_menu.tscn")
