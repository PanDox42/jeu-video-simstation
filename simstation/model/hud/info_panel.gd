## InfoPanel - Panneau d'informations des bâtiments
##
## Affiche les détails d'un bâtiment cliqué : nom, santé, bonheur, description.
## Pour le laboratoire, affiche aussi un bouton pour accéder à l'arbre de recherche.
## Se positionne automatiquement à droite de l'écran.
extends PanelContainer

const PANEL_BG_TEXTURE = preload("res://assets/hud/panel_info/panel_info_background.png")

## Police Minecraft pour le style rétro
const MINECRAFT_FONT = preload("res://font/Minecraftia-Regular.ttf")

## Conteneur vertical pour organiser les éléments
var boxContainer = VBoxContainer.new()

## Bouton pour fermer le panneau
var close_button = TextureButton.new()

## Label affichant le nom du bâtiment
var name_label = Label.new()

## Label affichant le bonheur apporté
var hapiness_label = Label.new()

## Label affichant la description
var description_label = Label.new()

## Bouton pour ouvrir l'arbre de recherche (visible uniquement pour le labo)
var search_button = Button.new()

## Initialise le panneau et ses éléments visuels
func _ready():
	var style_texture = StyleBoxTexture.new()
	style_texture.texture = PANEL_BG_TEXTURE
	
	# --- AJOUT : Marges internes (Padding) ---
	# Ces valeurs repoussent tout le contenu vers l'intérieur (en pixels)
	style_texture.content_margin_left = 20
	style_texture.content_margin_right = 20
	style_texture.content_margin_top = 15
	style_texture.content_margin_bottom = 20
	
	add_theme_stylebox_override("panel", style_texture)
	
	set_anchors_preset(Control.PRESET_CENTER_RIGHT)
	offset_right = -20
	grow_horizontal = Control.GROW_DIRECTION_BEGIN
	
	custom_minimum_size.x = 300
	description_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	styliser_labels()
	boxContainer.set_anchors_preset(Control.PRESET_FULL_RECT)
	boxContainer.add_theme_constant_override("separation", 10)
	
	add_child(boxContainer)

	close_button.texture_normal = load("res://assets/button/exit_button/exit_button.png")
	close_button.texture_hover = load("res://assets/button/exit_button/exit_button_hover.png")
	close_button.texture_pressed = load("res://assets/button/exit_button/exit_button_click.png")
	close_button.pressed.connect(hide_infos)
	close_button.ignore_texture_size = true
	close_button.custom_minimum_size = Vector2(40, 40)
	close_button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	
	search_button.text = "Ouvrir les recherches"
	search_button.add_theme_font_override("font", MINECRAFT_FONT)
	search_button.pressed.connect(open_search)
	search_button.hide() 
	
	description_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER 
	
	add_child(close_button)
	
	close_button.size_flags_horizontal = Control.SIZE_SHRINK_END
	close_button.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	
	boxContainer.add_child(name_label)
	boxContainer.add_child(hapiness_label)
	boxContainer.add_child(description_label)
	boxContainer.add_child(search_button)
	
	GlobalScript.connect("request_opening_info", Callable(self, "display_infos"))
	GlobalScript.connect("closure_request_info", Callable(self, "hide_infos"))
	
	hide()

## Affiche les informations d'un bâtiment
## @param id_batiment: ID du bâtiment à afficher
func display_infos(id_batiment: int):
	var infos = GlobalScript.get_info_building(id_batiment)
	
	if infos == null:
		print("Erreur : Bâtiment introuvable dans Global")
		return

	var name_type = infos["type"] 
	
	
	name_label.text = GlobalScript.get_building_display_name(name_type)
	name_label.add_theme_font_override("font", MINECRAFT_FONT)
	name_label.add_theme_font_override("font", MINECRAFT_FONT)
	
	hapiness_label.text = "Bonheur :  " + str(int(GlobalScript.get_building_hapiness(name_type))) + "%"
	hapiness_label.add_theme_font_override("font", MINECRAFT_FONT)
	
	description_label.text = "Description :  " + str(GlobalScript.get_building_description(name_type))
	description_label.add_theme_font_override("font", MINECRAFT_FONT)
	
	if name_type == "labo":
		search_button.show()
	else:
		search_button.hide()
	show()

## Cache le panneau d'informations
func hide_infos():
	hide()

## Ouvre l'interface de l'arbre de recherche
func open_search():
	GameManager.open_search()

## Applique un style personnalisé aux labels
func styliser_labels():
	var style = LabelSettings.new()
	style.font_size = 18
	style.outline_size = 4
	style.outline_color = Color.BLACK
	
	name_label.label_settings = style
	
	var title_style = style.duplicate()
	title_style.font_size = 24
	title_style.font_color = Color.YELLOW
	name_label.label_settings = title_style
