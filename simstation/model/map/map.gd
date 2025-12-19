## Map - Gestionnaire de la carte de jeu
##
## Gère le placement des bâtiments sur la carte et les interactions avec les bâtiments placés.
## Vérifie les collisions entre bâtiments et détecte les clics pour afficher les informations.
extends Node2D

## Nœud contenant tous les bâtiments placés sur la carte
@onready var buildings_layer = $NodeBuildings 

## Ajoute ce nœud au groupe "Map" pour le rendre détectable
func _ready():
	add_to_group("Map")

## Ajoute temporairement un bâtiment à la carte (mode ghost/preview)
## @param node: Sprite2D du bâtiment à ajouter temporairement
func add_temp_building(node: Sprite2D):
	buildings_layer.add_child(node)

## Valide le placement final d'un bâtiment
## Appelé quand le joueur confirme le placement
## @param node: Sprite2D du bâtiment à valider
func validate_building(node: Sprite2D):
	print("Bâtiment placé : ", node.get_meta("building_type"))

## Vérifie si un bâtiment peut être placé sans collision
## Teste les intersections avec tous les bâtiments existants
## @param ghost_building: Sprite2D du bâtiment en cours de placement
## @return: true si le placement est valide, false sinon
func is_placable(ghost_building: Sprite2D) -> bool:
	var ghost_rect = get_global_rect_of(ghost_building).grow(-2.0)
	
	for building in buildings_layer.get_children():
		if building == ghost_building: continue 
		
		if building.has_method("get_rect"):
			var other_rect = get_global_rect_of(building).grow(-2.0)
			
			if ghost_rect.intersects(other_rect):
				return false
				
	return true

## Détecte les clics sur les bâtiments et émet le signal d'information
## Appelé automatiquement par le système d'input de Godot
## @param event: Événement d'input (clic souris)
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

## Trouve le bâtiment situé sous le curseur de la souris
## Parcourt les bâtiments en ordre inverse (du plus récent au plus ancien)
## @return: Sprite2D du bâtiment sous la souris, ou null si aucun
func get_building_under_mouse() -> Sprite2D:
	var mouse_positionition = get_global_mouse_position()
	var childs = buildings_layer.get_children()
	childs.reverse() 
	
	for building in childs:
		if get_global_rect_of(building).has_point(mouse_positionition):
			return building
	return null

## Calcule le rectangle global (bounding box) d'un sprite
## Utilisé pour les calculs de collision et de sélection
## @param node: Sprite2D dont on veut calculer la zone
## @return: Rect2 représentant la zone globale du sprite
func get_global_rect_of(node: Sprite2D) -> Rect2:
	return node.get_global_transform() * node.get_rect()
