## DragBuilding - Système de placement de bâtiments par glisser-déposer
##
## Gère l'interface utilisateur pour le placement de bâtiments via drag & drop.
## Permet de glisser un bâtiment de l'inventaire vers la carte avec :
## - Grille visuelle temporaire pour l'alignement
## - Système d'aimantation (snapping) sur grille 64x64
## - Feedback visuel (vert = OK, rouge = collision)
## - Validation (clic gauche) ou annulation (clic droit)
extends TextureRect

## Son joué quand on prend un bâtiment
const PICK_BUILDING_SOUND = "res://assets/sounds/buildings/pick_for_place.mp3"

## Son joué lors d'un placement invalide
const BAB_PLACEMENT_SOUND = "res://assets/sounds/buildings/bad_placement.mp3"

## Son joué lors d'un placement réussi
const GOOD_PLACEMENT_SOUND = "res://assets/sounds/buildings/good_placement.mp3"

## Son joué quand pas assez de ressources
const NOT_ENOUGH_RESOUCES = "res://assets/sounds/buildings/not_enough_resources.mp3"

## Taille d'une cellule de la grille en pixels
@export var grid_size : int = 64

## Instance temporaire du bâtiment fantôme suivant la souris
var building_instance : Sprite2D = null

## Référence à la carte de jeu
var map_ref = null

## Indique si on est en mode placement
var dragging : bool = false

## Instance de la grille visuelle temporaire
var grid_visual_instance : Node2D = null

## Initialise le curseur
func _ready():
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


func _get_drag_data(_at_position):
	return null

## Gère le clic sur l'icône de bâtiment dans l'inventaire
## @param event: Événement d'input
func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if GlobalScript.get_currently_placing():
			print("Action impossible : un placement est déjà en cours")
			return
		if GlobalScript.get_building_inventory(name) > 0:
			start_dragging()
		else:
			GlobalScript.play_sound(NOT_ENOUGH_RESOUCES)
			print("Pas assez de ressources !")

## Gère les clics pendant le placement (validation/annulation)
## @param event: Événement d'input
func _unhandled_input(event):
	if dragging and building_instance:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed: 
				place_building()
				get_viewport().set_input_as_handled() 
			elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
				cancel_placement()
				get_viewport().set_input_as_handled()

## Met à jour la position du bâtiment fantôme selon la souris
## @param _delta: Delta time
func _process(_delta):
	if dragging and building_instance and map_ref:
		var mouse_global_pos = map_ref.get_global_mouse_position()
		var grid_pos = (mouse_global_pos / grid_size).floor() * grid_size

		building_instance.global_position = grid_pos
		update_visual_feedback()

## Démarre le mode placement : crée le fantôme et la grille
func start_dragging():
	GlobalScript.set_currently_placing(true)
	GlobalScript.play_sound(PICK_BUILDING_SOUND)
	
	var maps = get_tree().get_nodes_in_group("Map")
	if maps.size() > 0:
		map_ref = maps[0]
	else:
		return

	grid_visual_instance = GridDrawer.new()
	grid_visual_instance.cell_size = grid_size
	grid_visual_instance.z_index = 1 
	map_ref.add_child(grid_visual_instance)
	
	var texture_res = load("res://assets/buildings/"+name+".png")
	
	# --- CALCUL DE LA TAILLE ET DE L'ECHELLE ---
	var target_size = GlobalScript.get_size_building(name) # Récupère le 128 ou 64
	var tex_size = texture_res.get_size()
	
	building_instance = Sprite2D.new()
	building_instance.texture = texture_res 
	
	# On applique l'échelle : Taille voulue / Taille réelle de l'image
	# Exemple : 128 / 64 = scale de 2.0
	var ratio = float(target_size) / tex_size.x 
	building_instance.scale = Vector2(ratio, ratio)
	# -------------------------------------------
	
	building_instance.set_meta("id", GlobalScript.get_buildings_counts()+1)
	building_instance.set_meta("building_type", name)
	building_instance.z_index = 2
	
	var trect_hud_border = ColorRect.new()
	trect_hud_border.name = "BackgroundPlacement"
	trect_hud_border.mouse_filter = Control.MOUSE_FILTER_IGNORE
	trect_hud_border.color = Color(0.5, 0.5, 0.5, 0.5)
	
	# Le trect_hud_border doit correspondre à la taille de la texture (car il subit le scale du parent)
	trect_hud_border.size = tex_size
	trect_hud_border.position = -tex_size / 2
	trect_hud_border.show_behind_parent = true 
	
	building_instance.add_child(trect_hud_border)
	map_ref.add_temp_building(building_instance)
	
	dragging = true
	GlobalScript.edit_building(name, -1)

## Valide le placement si l'emplacement est libre
func place_building():
	if not building_instance: return
	
	if map_ref.is_placable(building_instance):
		GlobalScript.play_sound(GOOD_PLACEMENT_SOUND)
		
		building_instance.modulate = Color(1, 1, 1, 1)
		
		var trect_hud_border = building_instance.get_node_or_null("BackgroundPlacement")
		if trect_hud_border:
			trect_hud_border.queue_free()
		
		map_ref.validate_building(building_instance)
		
		GlobalScript.add_building(building_instance.get_meta("id"), name, building_instance.global_position) 
		
		building_instance = null
		dragging = false
		GlobalScript.set_currently_placing(false)
		remove_grid()
	else:
		GlobalScript.play_sound(BAB_PLACEMENT_SOUND)
		cancel_placement()

## Annule le placement et rembourse le bâtiment
func cancel_placement():
	if building_instance:
		building_instance.queue_free()
		building_instance = null
		GlobalScript.edit_building(name, 1)
	
	dragging = false
	GlobalScript.set_currently_placing(false)
	remove_grid()

## Supprime la grille visuelle
func remove_grid():
	if grid_visual_instance:
		grid_visual_instance.queue_free()
		grid_visual_instance = null

## Met à jour la couleur du fantôme (vert OK / rouge collision)
func update_visual_feedback():
	if map_ref.is_placable(building_instance):
		building_instance.modulate = Color(1, 1, 1, 0.7)
	else:
		building_instance.modulate = Color(1, 0.2, 0.2, 0.7)

## GridDrawer - Classe interne pour dessiner la grille temporaire
class GridDrawer extends Node2D:
	## Taille d'une cellule
	var cell_size = 64
	
	## Couleur de la grille
	var grid_color = Color(0.0, 0.0, 0.0, 1.0)
	
	## Zone de dessin
	var draw_area = Rect2(-6000, -6000, 14000, 14000)

	## Dessine les lignes de la grille
	func _draw():
		var left = int(draw_area.position.x / cell_size) * cell_size
		var right = int(draw_area.end.x)
		var top = int(draw_area.position.y / cell_size) * cell_size
		var bottom = int(draw_area.end.y)

		for x in range(left, right, cell_size):
			draw_line(Vector2(x, top), Vector2(x, bottom), grid_color)

		for y in range(top, bottom, cell_size):
			draw_line(Vector2(left, y), Vector2(right, y), grid_color)
