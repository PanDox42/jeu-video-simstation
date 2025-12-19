## Camera2D - Caméra de jeu avec contrôles drag et zoom
##
## Gère les contrôles de la caméra : déplacement par clic-glisser et zoom à la molette.
## Limite la caméra aux frontières de la carte pour éviter de sortir de la zone jouable.
## S'active/désactive selon l'état global de la caméra.
extends Camera2D

# === Configuration Zoom ===

## Incrément du zoom à chaque cran de molette
@export var zoom_step: float = 0.1

## Zoom minimum autorisé
@export var min_zoom: Vector2 = Vector2(0.6, 0.6)

## Zoom maximum autorisé
@export var max_zoom: Vector2 = Vector2(3, 3)

# === Configuration Limites Map ===

## Coin supérieur gauche de la carte
@export var map_limit_top_left: Vector2 = Vector2(-1000, -1000)

## Coin inférieur droit de la carte
@export var map_limit_bottom_right: Vector2 = Vector2(1000, 1000)

# === Variables Drag ===

## Indique si on est en train de faire glisser la caméra
var dragging: bool = false

## Initialise les limites de la caméra
func _ready() -> void:
	# Appliquer les limites aux limites natives de Godot
	limit_left = int(map_limit_top_left.x)
	limit_top = int(map_limit_top_left.y)
	limit_right = int(map_limit_bottom_right.x)
	limit_bottom = int(map_limit_bottom_right.y)

## Gère les entrées de la caméra (drag et zoom)
## @param event: Événement d'input
func _unhandled_input(event: InputEvent) -> void:
	if not GlobalScript.get_camera():
		return

	# === GESTION DU DRAG ===
	if event is InputEventMouseButton:
		if get_viewport().gui_get_focus_owner() != null:
			return
			
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
	
	elif event is InputEventMouseMotion and dragging:
		# Appliquer le mouvement
		position -= event.relative / zoom
		
		# Empêcher la position de sortir des limites
		position.x = clamp(position.x, map_limit_top_left.x, map_limit_bottom_right.x)
		position.y = clamp(position.y, map_limit_top_left.y, map_limit_bottom_right.y)

	# === GESTION DU ZOOM ===
	if event is InputEventMouseButton and event.pressed:
		var zoom_change = Vector2.ZERO
		
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_change = zoom * zoom_step 
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_change = -zoom * zoom_step 

		if zoom_change != Vector2.ZERO:
			var old_zoom = zoom
			var new_zoom = (zoom + zoom_change).clamp(min_zoom, max_zoom)
			
			if old_zoom == new_zoom:
				return
			
			zoom = new_zoom
			var mouse_position = get_global_mouse_position()
			position += (mouse_position - position) - (mouse_position - position) * (old_zoom / zoom)
			
			# Re-clamper après le zoom pour ne pas sortir de la map
			position.x = clamp(position.x, map_limit_top_left.x, map_limit_bottom_right.x)
			position.y = clamp(position.y, map_limit_top_left.y, map_limit_bottom_right.y)
			
			GameManager.set_current_zoom_cam(zoom)

## Recentre la caméra à l'origine
func recentrer_camera() -> void:
	position = Vector2.ZERO
