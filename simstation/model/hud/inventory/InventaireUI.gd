extends Control

# DESCRIPTION :
# Script gérant l'affichage dynamique de l'inventaire des bâtiments dans l'interface (UI).
# Il peuple une grille (GridContainer) avec les items disponibles dans `Global.inventaire`, 
# affiche les quantités en temps réel et attribue dynamiquement le script de Drag & Drop aux icônes.
# Les fonctions disponibles sont :
# _ready() : Initialise l'interface et s'abonne au signal global pour détecter les changements de stock.
# display_inventory : Vide la grille actuelle et régénère tous les boutons d'items.
# create_building_button : Instancie un conteneur avec l'image et la quantité, gère la texture (grisée si stock vide) et attache le script `drag_building.gd`.
# _on_batiment_changed : Met à jour le texte de la quantité et la color de l'icône d'un bâtiment spécifique sans recharger toute la liste.

@onready var grid = $ScrollInventory/MarginInventory/GridInventory

const MINECRAFT_FONT = preload("res://font/Minecraftia-Regular.ttf")
const DRAG_SCRIPT = preload("res://model/hud/inventory/drag_building.gd") 


func _ready():
	await get_tree().process_frame
	grid.add_theme_constant_override("v_separation", 15)
	
	display_inventory()
	
	GlobalScript.connect("unblocked_building", display_inventory)
	GlobalScript.connect("building_changed", _on_batiment_changed)

func display_inventory():
	print("INVENTAIRE RELOAD")
	for child in grid.get_children():
		child.queue_free()

	for building_name in GlobalScript.get_inventory().keys():
		var quantite = GlobalScript.get_inventory()[building_name]
		if(GlobalScript.get_buildings_unblocked(building_name)!=false):
			create_building_button(building_name, quantite)

func create_building_button(building_name: String, quantite: int):
	var container = VBoxContainer.new()
	container.name = "Box_" + building_name
	container.alignment = BoxContainer.ALIGNMENT_CENTER 

	var icon = TextureRect.new()
	icon.name = building_name 
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.custom_minimum_size = Vector2(64, 64) 
	
	var path_img = "res://assets/buildings/%s.png" % building_name
	if ResourceLoader.exists(path_img):
		icon.texture = load(path_img)
		icon.modulate = Color(0.658, 0.658, 0.658, 1.0) if quantite <= 0 else Color.WHITE
	else:
		icon.texture = PlaceholderTexture2D.new() 
		printerr("Image manquante pour : ", path_img)


	icon.set_script(DRAG_SCRIPT)
	icon.mouse_filter = Control.MOUSE_FILTER_STOP 

	var label = Label.new()
	label.name = "lbl"+building_name
	
	var display_name = GlobalScript.get_building_display_name(building_name)
	if display_name == "Laboratoire de recherche":
		display_name = "Laboratoire"
	
	label.text = "%s (x%d)" % [display_name, quantite]
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER 
	label.modulate = Color(0.658, 0.658, 0.658, 1.0) if quantite <= 0 else Color.WHITE
	label.add_theme_font_override("font", MINECRAFT_FONT)
	label.add_theme_font_size_override("font_size", 13)

	container.add_child(icon) 
	container.add_child(label) 
	grid.add_child(container)   

func _on_batiment_changed(building_name, new_val):
	for box in grid.get_children():
		if box.has_node(building_name):
			var icon = box.get_node(building_name)
			var lbl = box.get_node("lbl"+building_name)
			
			var display_name = GlobalScript.get_building_display_name(building_name)
			
			lbl.text = "%s (x%d)" % [display_name, new_val]
			icon.modulate = Color(0.658, 0.658, 0.658, 1.0) if new_val <= 0 else Color.WHITE
			lbl.modulate = Color(0.658, 0.658, 0.658, 1.0) if new_val <= 0 else Color.WHITE
