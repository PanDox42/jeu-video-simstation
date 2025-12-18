extends CanvasLayer

signal money_changed(money)

var tree: SearchTree
var node_positions = {}
var current_menu = null

# Mise en page
const X_SPACING = 300 # Écarté pour les boutons larges
const Y_SPACING = 150
const NODE_RADIUS = 30
const TREE_SPACING = 800

var dernier_round_connu = -1

# Références
@onready var scrollContainer = $TRectBackground/ScrollContainer

# Canvas interne
var tree_canvas = Control.new()

var root;

func _ready():
	GlobalScript.connect("round_changed", _on_round_changed)
		
	#set_process(false) # désactive _process, on éconameise du CPU !
	
	scrollContainer.add_child(tree_canvas)
	tree_canvas.draw.connect(_on_tree_canvas_draw)
	
	tree = SearchTree.new()

	# --- ARBRE DE DÉVELOPPEMENT DE LA STATION ---

	# NIVEAU 1 : La Racine (Vital)
	# On commence par le chauffage, car sans lui, personne ne survit au débarquement.
	root = tree.create_root("Survie Thermique", 1, 250000, 0, "Installe le réseau de chaleur primaire.", "boiler_room")
	root.unblocked = true

	# --- NIVEAU 2 : Infrastructures de Base (2 enfants max) ---

	# Branche A : Vie et Santé
	var node_vie = tree.add_child(root, "Meilleur isolation", 2, 450000, 15, "Permet d'avoir plus chaud dans les batiments", "")

	# Branche B : Recherche
	var node_sci = tree.add_child(root, "Méthode Scientifique", 2, 800000, 20, "Nouvelle méthode de recherche scientifique", "")


	# --- NIVEAU 3 : Spécialisations (2 enfants max par parent du N2) ---

	# Enfants de "Quartiers d'Hivernage" (Vie)
	var node_hospital = tree.add_child(node_vie, "Soutien Médical", 3, 750000, 40, "Indispensable pour traiter les engelures.", "hospital")
	var node_canteen = tree.add_child(node_vie, "Logistique Alimentaire", 3, 500000, 30, "Cuisine industrielle pour les rations d'hiver.", "canteen")

	# Enfants de "Méthode Scientifique" (Recherche)
	# Note : Ici on regroupe le Gym et la Rest Room sous le concept de "Santé Mentale" pour respecter les 7 nœuds
	var node_confort = tree.add_child(node_sci, "Équilibre Psychologique", 3, 600000, 50, "Débloque le Module Sportif et le Salon de détente.", "gym") 

	var node_astro = tree.add_child(node_sci, "Astronomie Polaire", 3, 2000000, 100, "Exploite la pureté de l'air pour l'observation.", "observatory")

	_update_tree_state_recursive(root)

	var start_x = 0
	_calculate_positions(root, Vector2(start_x, 0), 0)
	start_x += TREE_SPACING 

	_setup_scroll_area()

	_create_buttons_recursive(root)

func _on_round_changed():
	_check_research_completion()

# Vérifie si des recherches en cours sont finies
func _check_research_completion():
	var current_turn = GlobalScript.get_round()
	var changes_made = false
	
	# 1. Vérification des recherches terminées
	var recherches_names = GlobalScript.get_research_in_progress().keys()
	
	for name_recherche in recherches_names:
		var round_fin = GlobalScript.get_research_in_progress()[name_recherche]
		
		if current_turn >= round_fin:
			_complete_research(name_recherche)
			changes_made = true
	
	# 2. Logique de Refresh optimisée
	# On refresh SI une recherche est finie OU SI le round a changé (pour mettre à jour les textes)
	if changes_made or current_turn != dernier_round_connu:
		_refresh_ui()
		print("UI Mise à jour. round : ", current_turn)
		
		# TRES IMPORTANT : On met à jour la mémoire pour ne pas refresh à la frame suivante !
		dernier_round_connu = current_turn

func _complete_research(name_recherche: String):
	print("Recherche terminée : ", name_recherche)
	
	var node = null

	node = _find_node_by_name(root, name_recherche)
	
	if node:
		if(node.building_unblocked!=""):
			GlobalScript.set_building_unblocked(node.building_unblocked)
			GlobalScript.emit_signal("unblocked_building")
		# 2. Appliquer les gains
		GlobalScript.edit_money(GlobalScript.get_money() + node.money)
		if(node.building_unblocked!="") :
			GlobalScript.set_building_unblocked(node.building_unblocked)

		node.unblocked = true
	
	# 3. Mettre à jour Global
	GlobalScript.add_search_unblocked(name_recherche)
	GlobalScript.erase_research_in_progress(name_recherche)

# Fonction helper pour retrouver un noeud par son name
func _find_node_by_name(node, name_to_find):
	if node.name == name_to_find: return node
	for child in node.children:
		var res = _find_node_by_name(child, name_to_find)
		if res: return res
	return null

# Met à jour l'état local (unblocked/pas unblocked) en fonction du Global au démarrage
func _update_tree_state_recursive(node):
	if node == null: return
	
	# Est-ce que c'est déjà fini ?
	if node.name in GlobalScript.get_search_unblocked():
		node.unblocked = true
	else:
		node.unblocked = false
		
	for child in node.children:
		_update_tree_state_recursive(child)

# --- LOGIQUE D'INTERFACE ---

func _create_buttons_recursive(node: SearchTree.NodeData):
	if node == null: return
	
	var position = node_positions[node]
	var btn = TextureButton.new() 
	var texte = Label.new()
	var margin_container = MarginContainer.new()
	
	var texture_path_normal = "res://assets/button/search_tree/button_search.png"
	var texture_img_normal = load(texture_path_normal)
	
	var texture_path_hover = "res://assets/button/search_tree/button_search_hover.png"
	var texture_img_hover = load(texture_path_hover)
	
	var texture_path_clic = "res://assets/button/search_tree/button_search_click.png"
	var texture_img_clic = load(texture_path_clic)
	
	var font_path_normal = "res://font/Minecraftia-Regular.ttf"
	var font_normal = load(font_path_normal)
	
	texte.text = str(node.name)
	texte.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	texte.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	texte.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	texte.set_anchors_preset(Control.PRESET_FULL_RECT)
	texte.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	texte.size_flags_vertical = Control.SIZE_EXPAND_FILL
	texte.add_theme_color_override("font_color", Color.WHITE)
	texte.add_theme_font_override("font", font_normal)
	texte.add_theme_font_size_override("font_size", 14)
	texte.add_theme_constant_override("outline_size", 10)
	texte.add_theme_color_override("font_outline_color", Color.BLACK)
	
	margin_container.add_theme_constant_override("margin_left", 10)
	margin_container.add_theme_constant_override("margin_right", 10)
	
	margin_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	var button_size = Vector2(150, 70)
	
	btn.texture_normal = texture_img_normal
	btn.texture_hover = texture_img_hover
	btn.texture_pressed = texture_img_clic
	
	btn.custom_minimum_size = button_size
	btn.ignore_texture_size = true
	btn.stretch_mode = TextureButton.STRETCH_SCALE
	btn.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	btn.set_size(button_size)
	
	btn.set_position(position - button_size / 2) 
	
	margin_container.add_child(texte)
	btn.add_child(margin_container)
	tree_canvas.add_child(btn)
	# --- LOGIQUE ETAT DU BOUTON ---
	
	# Cas 1 : Recherche en cours
	if node.name in GlobalScript.get_research_in_progress():
		btn.disabled = true
		btn.modulate = Color(1.0, 0.569, 0.0, 0.553) # JAUNE = En cours
		dernier_round_connu = GlobalScript.get_research_in_progress()[node.name] - GlobalScript.get_round()
		texte.text += "\n(" + str(dernier_round_connu) + " rounds)"
		
	# Cas 2 : Parent non débloqué (Grisé)
	elif node.parent and not node.parent.unblocked:
		btn.disabled = true
		btn.modulate = Color(0.5, 0.5, 0.5) # GRIS
		
	# Cas 3 : Déjà acheté (Vert)
	elif node.unblocked:
		btn.disabled = false # On laisse actif pour pouvoir relire la description
		btn.modulate = Color(0.0, 1.0, 0.0, 0.745) # VERT
		btn.pressed.connect(func(): ajouter_retirer_menu_node(btn.position + Vector2(0, btn.size.y), node))
		
	# Cas 4 : Disponible à l'achat (Bleu/Blanc)
	else:
		btn.disabled = false
		btn.modulate = Color(1, 1, 1) # NORMAL
		btn.pressed.connect(func(): ajouter_retirer_menu_node(btn.position + Vector2(0, btn.size.y), node))
	
	for child in node.children:
		_create_buttons_recursive(child)

func ajouter_retirer_menu_node(position: Vector2, node: SearchTree.NodeData):
	if current_menu: current_menu.queue_free()
	
	var menu = Panel.new()
	var name = RichTextLabel.new()
	var search_buttonerche = Button.new()
	
	tree_canvas.add_child(menu) 
	menu.set_position(position)
	
	# Configuration de base du texte principal
	name.bbcode_enabled = true
	name.size = Vector2(280, 100)
	name.position = Vector2(10, 10)
	menu.add_child(name)

	if node.unblocked:
		# --- CAS 1 : RECHERCHE DÉJÀ FAITE ---
		name.text = "[b]" + node.name + "[/b]\n" + node.description + "\n\n[center][color=green]✔ RECHERCHE TERMINÉE[/color][/center]"
		menu.set_size(Vector2(300, 120))
		
	else:
		# --- CAS 2 : RECHERCHE DISPONIBLE ---
		
		# 1. Préparer le texte de description + Coût + Durée
		var texte_desc = "[b]" + node.name + "[/b]\n" + node.description + "\n"
		texte_desc += "[color=#aaaaaa]_______________________[/color]\n" # Ligne de séparation
		texte_desc += "[b]Gain :[/b] " + str(node.money) + "$ \n"
		texte_desc += "[b]Durée :[/b] " + str(node.round * 3) + " mois"
		name.text = texte_desc
		
		# Variable pour suivre la position verticale des éléments (curseur Y)
		var current_y = 115 
		
		# 2. Vérifier s'il y a un BÂTIMENT à débloquer
		if node.building_unblocked != "":
			var bat_label = RichTextLabel.new()
			# On récupère le name propre du bâtiment (index 3 du tableau buildings_info)
			var building_name = GlobalScript.get_building_display_name(node.building_unblocked)
			
			bat_label.bbcode_enabled = true
			bat_label.text = "[color=yellow]🔓 Débloque : " + building_name + "[/color]"
			bat_label.size = Vector2(280, 25)
			bat_label.position = Vector2(10, current_y)
			
			menu.add_child(bat_label)
			current_y += 25 # On décale le curseur vers le bas
		
		# 3. Placer le BOUTON en fonction du curseur Y
		search_buttonerche.text = "Lancer (" + str(node.round) + " rounds)"
		search_buttonerche.size = Vector2(280, 30)
		search_buttonerche.position = Vector2(10, current_y + 5) # +5 pour un petit espacement
		
		# Connexion du signal
		search_buttonerche.pressed.connect(func(): lancer_recherche(node))
		menu.add_child(search_buttonerche)
		
		# 4. Ajuster la taille finale du panneau
		menu.set_size(Vector2(300, current_y + 45)) # 45 = Hauteur bouton + Marge bas

	current_menu = menu

func lancer_recherche(node):
	if current_menu: current_menu.queue_free()
	
	# Calcul du round de fin
	var current_round = GlobalScript.get_round()
	var round_fin = current_round + node.round
	
	# Enregistrement dans le Global
	GlobalScript.set_research_in_progress(node.name, round_fin)
	
	print("Recherche lancée : " + node.name + ". Fin au round " + str(round_fin))
	
	# Mise à jour de l'interface
	_refresh_ui()

func _refresh_ui():
	# On supprime tout
	for child in tree_canvas.get_children():
		child.queue_free()
	
	# On attend que Godot nettoie la mémoire
	await get_tree().process_frame 
	
	# SECURITÉ : Si le joueur a fermé le menu pendant l'attente, on arrête tout
	if not is_inside_tree():
		return

	_create_buttons_recursive(root)
		
	tree_canvas.queue_redraw()

# --- FONCTIONS MATHEMATIQUES INCHANGEES ---
func _calculate_positions(node, position, depth):
	if node == null: return
	var x_offset = _get_subtree_width(node) * X_SPACING * -0.5
	node_positions[node] = Vector2(position.x, depth * Y_SPACING)
	var child_x = position.x + x_offset
	for child in node.children:
		node_positions[child] = Vector2(child_x, (depth + 1) * Y_SPACING)
		_calculate_positions(child, Vector2(child_x, (depth + 1) * Y_SPACING), depth + 1)
		child_x += _get_subtree_width(child) * X_SPACING

func _setup_scroll_area():
	var min_x = INF; var max_x = -INF; var min_y = INF; var max_y = -INF
	for position in node_positions.values():
		min_x = min(min_x, position.x); max_x = max(max_x, position.x)
		min_y = min(min_y, position.y); max_y = max(max_y, position.y)
	var padding = Vector2(100, 100)
	var shift_vector = Vector2(-min_x, -min_y) + padding
	for node in node_positions.keys(): node_positions[node] += shift_vector
	tree_canvas.custom_minimum_size = Vector2((max_x - min_x) + padding.x * 2, (max_y - min_y) + padding.y * 2)
	tree_canvas.queue_redraw()

func _get_subtree_width(node) -> int:
	if node.children.size() == 0: return 1
	var width = 0
	for child in node.children: width += _get_subtree_width(child)
	return width

func _on_tree_canvas_draw():
	if tree == null or tree.root == null: return
	_draw_lines_recursive(root)

func _draw_lines_recursive(node):
	if node == null: return
	var position = node_positions[node]
	for child in node.children:
		var child_pos = node_positions[child]
		tree_canvas.draw_line(position + Vector2(0, NODE_RADIUS), child_pos - Vector2(0, NODE_RADIUS), Color(0.6, 0.6, 0.6), 2)
		_draw_lines_recursive(child)

func _on_exit_button_pressed() -> void:
	var play_scene = get_tree().current_scene
	var hud = play_scene.get_node("hud")
	if hud.has_node("ArbreRecherche"):
		hud.get_node("ArbreRecherche").visible = false
		GlobalScript.set_camera(!GlobalScript.get_camera())
