extends Node2D

# DESCRIPTION :
# Script principal de la gestion de la carte (Map). Il sert de conteneur pour les bâtiments 
# et gère la logique de placement (collisions) ainsi que les interactions (clics) sur les bâtiments existants.
# La variable `buildings_layer` référence le nœud parent où sont stockés tous les bâtiments.
# Les fonctions disponibles sont :
# _ready() : Ajoute ce nœud au groupe "Map" pour qu'il soit détectable par les outils de construction.
# add_temp_building : Ajoute visuellement le bâtiment en cours de déplacement (ghost) à la scène.
# validate_building : Confirme le placement final d'un bâtiment (point d'entrée pour la logique de persistance).
# is_placable : Vérifie si le bâtiment en cours chevauche un bâtiment existant via des calculs d'intersection de rectangles (Rect2).
# _unhandled_input : Détecte les clics gauche pour sélectionner un bâtiment et émettre le signal global d'information.
# get_building_under_mouse : Identifie et reroundne le bâtiment situé sous le curseur de la souris.
# get_global_rect_of : Fonction utilitaire qui calcule la zone rectangulaire globale (bounding box) d'un nœud.

@onready var buildings_layer = $NodeBuildings 

func _ready():
	add_to_group("Map")

func add_temp_building(node: Sprite2D):
	buildings_layer.add_child(node)

func validate_building(node: Sprite2D):
	print("Bâtiment placé : ", node.get_meta("building_type"))

func is_placable(ghost_building: Sprite2D) -> bool:
	var ghost_rect = get_global_rect_of(ghost_building).grow(-2.0)
	
	for building in buildings_layer.get_children():
		if building == ghost_building: continue 
		
		if building.has_method("get_rect"):
			var other_rect = get_global_rect_of(building).grow(-2.0)
			
			if ghost_rect.intersects(other_rect):
				return false
				
	return true
	
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and GlobalScript.get_currently_placing()!=true:
		
		var building_click = get_building_under_mouse()
		
		if building_click:
			var id_a_envoyer;
			# On vérifie si une étiquette "building_type" a été collée sur le sprite
			if building_click.has_meta("id"):
				id_a_envoyer = building_click.get_meta("id")
			
			print("Clic détecté sur : ", building_click.get_meta("building_type"), " -> Envoi signal : ", id_a_envoyer)
			GlobalScript.request_opening_info.emit(id_a_envoyer)

func get_building_under_mouse() -> Sprite2D:
	var mouse_positionition = get_global_mouse_position()
	var childs = buildings_layer.get_children()
	childs.reverse() 
	
	for building in childs:
		if get_global_rect_of(building).has_point(mouse_positionition):
			return building
	return null

func get_global_rect_of(node: Sprite2D) -> Rect2:
	return node.get_global_transform() * node.get_rect()
