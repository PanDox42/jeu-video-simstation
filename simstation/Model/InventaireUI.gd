extends Control

# DESCRIPTION :
# Script gérant l'affichage dynamique de l'inventaire des bâtiments dans l'interface (UI).
# Il peuple une grille (GridContainer) avec les items disponibles dans `Global.inventaire`, 
# affiche les quantités en temps réel et attribue dynamiquement le script de Drag & Drop aux icônes.
# Les fonctions disponibles sont :
# _ready() : Initialise l'interface et s'abonne au signal global pour détecter les changements de stock.
# afficher_inventaire : Vide la grille actuelle et régénère tous les boutons d'items.
# creer_bouton_batiment : Instancie un conteneur avec l'image et la quantité, gère la texture (grisée si stock vide) et attache le script `drag_building.gd`.
# _on_batiment_changed : Met à jour le texte de la quantité et la couleur de l'icône d'un bâtiment spécifique sans recharger toute la liste.

@onready var grid = $ScrollInventaire/MarginInventaire/GridInventaire

func _ready():
	await get_tree().process_frame
	grid.add_theme_constant_override("v_separation", 15)
	
	afficher_inventaire()
	
	GlobalScript.connect("debloque_bat", afficher_inventaire)
	GlobalScript.connect("batiment_changed", _on_batiment_changed)

func afficher_inventaire():
	print("INVENTAIRE RELOAD")
	for child in grid.get_children():
		child.queue_free()

	for nom_batiment in GlobalScript.get_inventaire().keys():
		var quantite = GlobalScript.get_inventaire()[nom_batiment]
		if(GlobalScript.get_batiments_debloque(nom_batiment)!=false):
			creer_bouton_batiment(nom_batiment, quantite)

func creer_bouton_batiment(nom_batiment: String, quantite: int):
	var container = VBoxContainer.new()
	container.name = "Box_" + nom_batiment
	container.alignment = BoxContainer.ALIGNMENT_CENTER 

	var icon = TextureRect.new()
	icon.name = nom_batiment 
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.custom_minimum_size = Vector2(64, 64) 
	
	var path_img = "res://assets/batiments/%s.png" % nom_batiment
	if ResourceLoader.exists(path_img):
		icon.texture = load(path_img)
		icon.modulate = Color(0.658, 0.658, 0.658, 1.0) if quantite <= 0 else Color.WHITE
	else:
		icon.texture = PlaceholderTexture2D.new() 
		printerr("Image manquante pour : ", path_img)

	var drag_script = load("res://Model/drag_building.gd") 
	icon.set_script(drag_script)
	icon.mouse_filter = Control.MOUSE_FILTER_STOP 

	var label = Label.new()
	label.name = "lbl"+nom_batiment
	
	var nom_affiche = GlobalScript.get_batiment_info(nom_batiment)[3]
	if nom_affiche == "Laboratoire de recherche":
		nom_affiche = "Laboratoire"
	
	label.text = "%s (x%d)" % [nom_affiche, quantite]
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER 
	label.modulate = Color(0.658, 0.658, 0.658, 1.0) if quantite <= 0 else Color.WHITE

	container.add_child(icon) 
	container.add_child(label) 
	grid.add_child(container)   

func _on_batiment_changed(nom_batiment, new_val):
	for box in grid.get_children():
		if box.has_node(nom_batiment):
			var icon = box.get_node(nom_batiment)
			var lbl = box.get_node("lbl"+nom_batiment)
			
			var nom_affiche = GlobalScript.get_batiment_info(nom_batiment)[3]
			if nom_affiche == "Laboratoire de recherche":
				nom_affiche = "Laboratoire"
			
			lbl.text = "%s (x%d)" % [nom_affiche, new_val]
			icon.modulate = Color(0.658, 0.658, 0.658, 1.0) if new_val <= 0 else Color.WHITE
			lbl.modulate = Color(0.658, 0.658, 0.658, 1.0) if new_val <= 0 else Color.WHITE
