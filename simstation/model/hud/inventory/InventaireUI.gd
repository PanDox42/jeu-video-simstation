## InventaireUI - Interface graphique de l'inventaire
##
## Affiche dynamiquement l'inventaire des bâtiments dans une grille.
## Génère une carte pour chaque type de bâtiment débloqué avec son image et sa quantité.
## Grise automatiquement les bâtiments en quantité zéro.
## Attache le script de drag & drop à chaque icône pour permettre le placement.
extends Control

## Grille contenant les cartes de bâtiments
@onready var grid = $ScrollInventory/MarginInventory/GridInventory

## Police Minecraft pour le style rétro
const MINECRAFT_FONT = preload("res://font/Minecraftia-Regular.ttf")

## Script de drag & drop attaché dynamiquement aux icônes
const DRAG_SCRIPT = preload("res://model/hud/inventory/drag_building.gd") 


## Initialise l'inventaire et se connecte aux signaux
func _ready():
	await get_tree().process_frame
	grid.add_theme_constant_override("v_separation", 15)
	
	display_inventory()
	
	GlobalScript.connect("unblocked_building", display_inventory)
	GlobalScript.connect("building_changed", _on_batiment_changed)

## Régénère complètement l'inventaire
## Efface tous les éléments et les recrée depuis l'inventaire global
func display_inventory():
	print("INVENTAIRE RELOAD")
	for child in grid.get_children():
		child.queue_free()

	for building_name in GlobalScript.get_inventory().keys():
		var quantite = GlobalScript.get_inventory()[building_name]
		if(GlobalScript.get_buildings_unblocked(building_name)!=false):
			create_building_button(building_name, quantite)

## Crée une carte de bâtiment dans l'inventaire
## Génère un conteneur avec l'icône et le label de quantité
## Attache le script de drag & drop à l'icône
## Grise l'icône si la quantité est zéro
## @param building_name: Nom interne du bâtiment
## @param quantite: Quantité disponible
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

## Met à jour la quantité affichée et la couleur d'un bâtiment spécifique
## Utilisé pour éviter de régénérer tout l'inventaire quand une quantité change
## @param building_name: Nom du bâtiment à mettre à jour
## @param new_val: Nouvelle quantité
func _on_batiment_changed(building_name, new_val):
	for box in grid.get_children():
		if box.has_node(building_name):
			var icon = box.get_node(building_name)
			var lbl = box.get_node("lbl"+building_name)
			
			var display_name = GlobalScript.get_building_display_name(building_name)
			
			lbl.text = "%s (x%d)" % [display_name, new_val]
			icon.modulate = Color(0.658, 0.658, 0.658, 1.0) if new_val <= 0 else Color.WHITE
			lbl.modulate = Color(0.658, 0.658, 0.658, 1.0) if new_val <= 0 else Color.WHITE
