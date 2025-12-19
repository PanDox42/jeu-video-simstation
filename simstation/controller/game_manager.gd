## GameManager - Contrôleur principal du jeu
##
## Singleton qui gère l'état global du jeu, incluant la référence à la carte courante,
## le zoom de la caméra et le chemin du bâtiment en cours de placement.
extends Node

## Référence vers la carte actuellement active dans la scène
var current_map: Node = null

## Niveau de zoom actuel de la caméra
var zoom_cam: Vector2

## Référence vers le nœud du bâtiment en cours de placement
var path_building: Node

## Définit la carte actuellement active
## @param map: Le nœud de la carte à définir comme carte courante
func set_current_map(map: Node):
	current_map = map

## Récupère la carte actuellement active
## @return: Le nœud de la carte courante
func get_current_map() -> Node:
	return current_map
	
## Définit le niveau de zoom de la caméra
## @param current_zoom_cam: Vecteur représentant le niveau de zoom (x, y)
func set_current_zoom_cam(current_zoom_cam : Vector2):
	zoom_cam = current_zoom_cam

## Récupère le niveau de zoom actuel de la caméra
## @return: Le vecteur de zoom actuel
func get_zoom_cam() -> Vector2:
	return zoom_cam
	
## Ouvre l'interface de l'arbre de recherche
## Charge et affiche la scène de l'arbre de recherche dans le HUD
func open_search():
	load_scene("res://View/search_tree.tscn", "ArbreRecherche")
	
## Charge dynamiquement une scène dans le HUD
## Si la scène existe déjà, bascule sa visibilité au lieu de la recharger
## @param chemin_scene: Chemin vers le fichier .tscn à charger
## @param name_node: Nom à donner au nœud instancié
func load_scene(chemin_scene, name_node):
	var arbre_scene = load(chemin_scene)
	var play_scene = get_tree().current_scene
	var hud = play_scene.get_node("hud") 

	if not hud.has_node(name_node):
		var instance = arbre_scene.instantiate()
		instance.name = name_node
		hud.add_child(instance)
	else:
		var node = hud.get_node(name_node)
		node.visible = !node.visible  

	GlobalScript.set_camera(!GlobalScript.get_camera())
