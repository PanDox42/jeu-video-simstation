## ButtonAction - Gestionnaire de navigation pour les boutons de menu
##
## Gère l'ouverture et la fermeture des menus principaux du jeu (Shop, Pause, etc.)
## Charge dynamiquement les scènes de menu dans le HUD et gère leur visibilité.
## Permet aussi de bloquer/débloquer la caméra lors de l'ouverture des menus.
extends TextureButton

## Ouvre le menu de la boutique
## Charge la scène shop.tscn dans le HUD ou bascule sa visibilité
func _on_pressed_shop() -> void:
	load_scene("res://view/shop.tscn", "Shop")

## Ouvre le menu pause
## Charge la scène pause.tscn dans le HUD ou bascule sa visibilité
func _on_pressed_pause():
	load_scene("res://view/pause.tscn", "Pause")

## Surveille les entrées clavier pour le menu pause
## Détecte l'action "pause" (touche Échap) pour ouvrir le menu
## @param _delta: Delta time
func _physics_process(_delta):
	if Input.is_action_just_pressed("pause"):
		_on_pressed_pause()

## Charge dynamiquement une scène dans le HUD ou bascule sa visibilité
## Si la scène n'existe pas encore, elle est instanciée et ajoutée au HUD
## Si elle existe déjà, sa visibilité est inversée
## @param scene_path: Chemin vers le fichier .tscn à charger
## @param node_name: Nom à donner au nœud dans le HUD
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


## Ferme un menu spécifique en le rendant invisible
## Utilisé pour forcer la fermeture d'un menu sans toggle
## @param node_name: Nom du nœud de menu à fermer
func exit_button(node_name):
	var play_scene = get_tree().current_scene
	var hud = play_scene.get_node("hud")

	if hud.has_node(node_name):
		hud.get_node(node_name).visible = false
