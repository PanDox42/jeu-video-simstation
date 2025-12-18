extends TextureButton

# DESCRIPTION :
# Script de gestion de l'interface utilisateur (UI) et de la navigation entre les différents menus.
# Il permet de charger dynamiquement des scènes (Shop, Arbre de recherche, Pause) dans le HUD,
# ou de basculer leur visibilité si elles sont déjà instanciées, tout en gérant l'activation de la caméra.
# Les fonctions disponibles sont :
# _on_pressed_shop, _on_pressed_recherches, _on_pressed_pause : Fonctions liées aux boutons pour ouvrir les menus correspondants.
# _physics_process : Surveille les entrées joueur pour déclencher le menu pause via le clavier.
# load_scene : Fonction générique qui instancie une scène dans le HUD ou inverse sa visibilité (toggle), et bloque/débloque la caméra.
# exit_button : Force la fermeture d'un menu spécifique (le rend invisible) et réactive la caméra.

func _on_pressed_shop() -> void:
	load_scene("res://View/shop.tscn", "Shop")

func _on_pressed_pause():
	load_scene("res://View/pause.tscn", "Pause")

func _physics_process(_delta):
	if Input.is_action_just_pressed("pause"):
		_on_pressed_pause()

func load_scene(scene_path, node_name):
	var arbre_scene = load(scene_path)
	var play_scene = get_tree().current_scene
	var hud = play_scene.get_node("hud") 

	if not hud.has_node(node_name):
		var instance = arbre_scene.instantiate()
		instance.name = node_name
		hud.add_child(instance)
	else:
		var node = hud.get_node(node_name)
		node.visible = !node.visible  


func exit_button(node_name):
	var play_scene = get_tree().current_scene
	var hud = play_scene.get_node("hud")

	if hud.has_node(node_name):
		hud.get_node(node_name).visible = false
