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
	await get_tree().process_frame
	spawn_saved_buildings()
	add_to_group("Map")
	
func spawn_saved_buildings():
	var saved_buildings = GlobalScript.get_buildings_place()
	
	for id_key in saved_buildings:
		# On convertit explicitement la String en int pour satisfaire la fonction
		var id_int = int(id_key)
		var data = saved_buildings[id_key]
		_create_building_instance(id_int, data)
		
func _create_building_instance(id: int, data: Dictionary):
	var type_name = data["type"]
	var texture_path = "res://assets/buildings/" + type_name + ".png"
	
	if not FileAccess.file_exists(texture_path):
		return

	var tex = load(texture_path)
	var new_building = Sprite2D.new()
	new_building.texture = tex
	
	# --- LOGIQUE DE POSITION SÉCURISÉE ---
	var p = data["position"]
	
	if p is Dictionary:
		# Si c'est bien notre nouveau format {x, y}
		new_building.global_position = Vector2(p["x"], p["y"])
	elif p is String:
		# Sécurité pour les vieilles sauvegardes corrompues
		# On transforme le texte "(x, y)" en vrai Vector2
		p = p.replace("(", "").replace(")", "").split(",")
		new_building.global_position = Vector2(float(p[0]), float(p[1]))
	# -------------------------------------

	# Réglages visuels identiques au placement manuel
	var target_size = GlobalScript.get_size_building(type_name)
	var ratio = float(target_size) / tex.get_size().x
	new_building.scale = Vector2(ratio, ratio)
	
	# Ajout au parent correct pour être cliquable
	buildings_layer.add_child(new_building)
	new_building.z_index = 2 
	
	# Métadonnées
	new_building.set_meta("id", id)
	new_building.set_meta("building_type", type_name)

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
