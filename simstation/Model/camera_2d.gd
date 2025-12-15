extends Camera2D

# --- Config Zoom ---
@export_category("Zoom")
@export var zoom_step: float = 0.1
@export var min_zoom: Vector2 = Vector2(0.8, 0.8)
@export var max_zoom: Vector2 = Vector2(3, 3)

# --- Config Limites (Map) ---
@export_category("Limites Map")
# Définis ici la taille de ta map en pixels (Top-Left et Bottom-Right)
@export var map_limit_top_left: Vector2 = Vector2(-1000, -1000)
@export var map_limit_bottom_right: Vector2 = Vector2(1000, 1000)

# --- Variables Drag ---
var dragging: bool = false

func _ready() -> void:
	# Optionnel : Appliquer ces limites aux limites natives de Godot 
	# pour que le moteur sache aussi où s'arrêter visuellement
	limit_left = int(map_limit_top_left.x)
	limit_top = int(map_limit_top_left.y)
	limit_right = int(map_limit_bottom_right.x)
	limit_bottom = int(map_limit_bottom_right.y)

func _unhandled_input(event: InputEvent) -> void:
	if not GlobalScript.get_camera():
		return

	# --- GESTION DU DRAG ---
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
	
	elif event is InputEventMouseMotion and dragging:
		# 1. On applique le mouvement
		position -= event.relative / zoom
		
		# 2. CORRECTION CRITIQUE : On empêche la position de sortir des limites
		# Cela évite le problème où la caméra reste "coincée"
		position.x = clamp(position.x, map_limit_top_left.x, map_limit_bottom_right.x)
		position.y = clamp(position.y, map_limit_top_left.y, map_limit_bottom_right.y)

	# --- GESTION DU ZOOM ---
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
			var mouse_pos = get_global_mouse_position()
			position += (mouse_pos - position) - (mouse_pos - position) * (old_zoom / zoom)
			
			# On re-clampe aussi après le zoom pour ne pas sortir de la map en zoomant
			position.x = clamp(position.x, map_limit_top_left.x, map_limit_bottom_right.x)
			position.y = clamp(position.y, map_limit_top_left.y, map_limit_bottom_right.y)
			
			GameManager.set_current_zoom_cam(zoom)

func recentrer_camera() -> void:
	# Définir la position au centre (0, 0)
	position = Vector2.ZERO
