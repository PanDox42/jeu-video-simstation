extends CanvasLayer

@onready var batiments_container = $background/ScrollContainer/Batiments

const MINECRAFT_FONT = preload("res://font/Minecraftia-Regular.ttf")


func _ready():
	GlobalScript.connect("debloque_bat", charger_batiments)
	charger_batiments()

func charger_batiments():
	print("SHOP RELOAD")
	for child in batiments_container.get_children():
		child.queue_free()
		
	for batiment in GlobalScript.get_inventaire().keys() :
		if GlobalScript.get_batiments_debloque(batiment) :
			initialize(batiment)
		

func initialize(building_name: String):
	var vboxBat = VBoxContainer.new()
	var separateur = ColorRect.new()
	var bat_name = RichTextLabel.new()
	var image = TextureRect.new()
	var cost = RichTextLabel.new()
	var button = TextureButton.new()
	
	var vboxDesc = VBoxContainer.new()
	var rect_desc = TextureRect.new()
	var contenu_description = VBoxContainer.new()
	var description = RichTextLabel.new()
	
	bat_name.add_theme_font_override("normal_font", MINECRAFT_FONT)
	cost.add_theme_font_override("normal_font", MINECRAFT_FONT)
	description.add_theme_font_override("normal_font", MINECRAFT_FONT)

	# Récupérer les informations via GlobalScript
	var prix = GlobalScript.get_batiment_prix(building_name)
	var info_array = GlobalScript.get_batiment_info(building_name)

	# Assurez-vous que info_array[3] est le nom traduit, et info_array[2] est la description
	var translated_name = info_array[3] 
	var description_text = info_array[2]
	
	vboxBat.custom_minimum_size = Vector2(512, 300)
	
	separateur.color = Color(255, 255, 255)
	separateur.custom_minimum_size = Vector2(0, 2)
	
	bat_name.bbcode_enabled = true
	bat_name.bbcode_text = "[center][font_size=48]" + translated_name
	bat_name.fit_content = true
	
	var path = "res://assets/batiments/" + building_name + ".png"
	image.texture = load(path)
	image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	image.custom_minimum_size = Vector2(300, 290)
	
	cost.bbcode_enabled = true
	var hex = "00D900"
	cost.bbcode_text = "[center][font_size=48][color=#" + hex + "]" + GlobalScript.format_money(prix) + " €[/color][/font_size]\n[font_size=4] "
	cost.fit_content = true
	
	button.texture_normal = preload("res://assets/button/shop_button/shop_button.png")
	button.texture_hover = preload("res://assets/button/shop_button/shop_button_hover.png")
	button.texture_pressed = preload("res://assets/button/shop_button/shop_button_click.png")
	button.size = Vector2(80, 80)
	button.scale = Vector2(0.9, 0.9)
	button.stretch_mode = TextureButton.STRETCH_SCALE
	button.layout_direction = Control.LAYOUT_DIRECTION_RTL
	
	button.connect("pressed",acheter_batiment.bind(building_name))
	
	cost.add_child(button)
	
	
	vboxDesc.custom_minimum_size = Vector2(510, 300)
	
	contenu_description.add_theme_constant_override("separation", 10)
	
	rect_desc.texture = preload("res://assets/background/popup_background.png")
	rect_desc.custom_minimum_size = Vector2(0, 400)
	rect_desc.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	
	description.bbcode_enabled = true
	description.custom_minimum_size = Vector2(450, 0)
	description.bbcode_text = "[font_size=26]\n[/font_size][center][font_size=48]DESCRIPTION[/font_size]\n[font_size=32]" + description_text
	description.fit_content = true
	
	contenu_description.add_child(description)
	
	var sante = TextureRect.new()
	sante.texture = preload("res://assets/bar/health_icon.png")
	sante.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	sante.custom_minimum_size = Vector2(50, 50)
	sante.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN 
	sante.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	
	contenu_description.add_child(sante)

	var efficacite = TextureRect.new()
	efficacite.texture = preload("res://assets/bar/efficiency_icon.png")
	efficacite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	efficacite.custom_minimum_size = Vector2(50, 50)
	efficacite.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN 
	efficacite.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	
	contenu_description.add_child(efficacite)

	
	var bonheur = TextureRect.new()
	bonheur.texture = preload("res://assets/bar/happiness_icon.png")
	bonheur.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	bonheur.custom_minimum_size = Vector2(50, 50)
	bonheur.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN 
	bonheur.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	
	contenu_description.add_child(bonheur)
	
	
	rect_desc.add_child(contenu_description)
	
	contenu_description.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT, Control.PRESET_MODE_MINSIZE, 20)
	
	
	vboxDesc.add_child(rect_desc)
	
	vboxBat.add_child(separateur)
	vboxBat.add_child(bat_name)
	vboxBat.add_child(image)
	vboxBat.add_child(cost)
	
	batiments_container.add_child(vboxBat)
	batiments_container.add_child(vboxDesc)

func _on_exit_button_pressed() -> void:
	var play_scene = get_tree().current_scene
	var hud = play_scene.get_node("hud")

	if hud.has_node("Shop"):
		hud.get_node("Shop").visible = false


func acheter_batiment(nom_batiment):
	var arbre_scene = load("res://View/buy_confirmation.tscn")
	var play_scene = get_tree().current_scene
	var hud = play_scene.get_node("hud") 

	if not hud.has_node("BuyConfirmation"):
		var instance = arbre_scene.instantiate()
		instance.name = "BuyConfirmation"
		instance.batiment = nom_batiment
		hud.add_child(instance)

	else:
		var node = hud.get_node("BuyConfirmation")
		node.visible = !node.visible  
