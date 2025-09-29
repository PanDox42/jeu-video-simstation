extends Sprite2D

var batiment_instance = null
var map = null
var dragging = false
@export var delay = 0.01 # variable dictant l'animation de drag and drop
@export var speed_ap = 10 #vitesse de l'animation de automatic placement
var mouse_offset # pour centrer le drop au millieu de la sprite
var automatic_placement = false

#on recupere la map actuelle
func _process(_delta):
	if map == null and GameManager.get_current_map():
		map = GameManager.get_current_map()

#permet au batiment de suivre le pointeur de la souris lorsqu'il est deplace
#et place automatiquement le batiement
func _physics_process(delta: float) -> void:
	if dragging:
		var tween = get_tree().create_tween()
		tween.tween_property(batiment_instance, "position",get_world_mouse_position() - mouse_offset , delay * delta)
	if automatic_placement and !map.is_placable(batiment_instance)[0]:
		var tween = get_tree().create_tween()
		tween.tween_property(batiment_instance, "position", batiment_instance.position - map.is_placable(batiment_instance)[1] * Vector2(speed_ap, speed_ap), delay * delta)
	else:
		automatic_placement = false
	if !dragging and map and batiment_instance :
		map.delete_square()
		
#detecte le clic de la souris et gere le drag
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if get_rect().has_point(to_local(event.position)):
				map.show_square()
				var batiment = find_building_scene()
				batiment_instance = batiment.instantiate()
				add_building_map()
				dragging = true
				mouse_offset = Vector2(0,0)
		elif dragging:
			dragging = false
			place_building()


#fonction qui renvoie la position general du pointeur de la souris 
#sans prendre le zoom ou le deplacement de la camera
func get_world_mouse_position() -> Vector2:
	var camera = get_viewport().get_camera_2d()
	if camera:
		return camera.get_global_mouse_position()
	else:
		return get_global_mouse_position()


#fonction qui cherche le fichier contenant la scene du batiment selectione
func find_building_scene() -> Resource:
	if FileAccess.file_exists("res://batiments/"+ self.name +".tscn"):
		return load("res://batiments/"+ self.name +".tscn")
	else:
		return null

#fonction pour placer le batiment et qui verifie si l'emplacement choisis 
#est libre sinon decale le batiment
func place_building():
	dragging = false
	if map.is_placable(batiment_instance)[0]:
		print(map.is_placable(batiment_instance)[1])
		batiment_instance.position = get_world_mouse_position() - mouse_offset
		map.delete_square()
	else:
		automatic_placement = true



#fonction pour ajouter le batiment dans la map et le mettre dans le bon dossiers des batiments
func add_building_map():
	var folder_buildings = map.get_child(2)
	folder_buildings.add_child(batiment_instance)
	
	
#afficher les carré autour des batiments pour voir leurs zone placable
func show_square():
	map.afficher_carre()

#enlever l'afffichage des carre
func delete_square():
	map.delete_square()
