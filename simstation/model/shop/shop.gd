extends CanvasLayer

@onready var buildings_container = $TRectBackground/ScrollBuildings/Buildings

const MINECRAFT_FONT = preload("res://font/Minecraftia-Regular.ttf")


func _ready():
	GlobalScript.connect("unblocked_building", load_buildings)
	load_buildings()

func load_buildings():
	print("SHOP RELOAD")
	for child in buildings_container.get_children():
		child.queue_free()
		
	for building in GlobalScript.get_inventory().keys() :
		if GlobalScript.get_buildings_unblocked(building) && building != "labo":
			initialize(building)


func initialize(building_name: String):
	var vboxBat = VBoxContainer.new()
	var separator = ColorRect.new()
	var bat_name = RichTextLabel.new()
	var image = TextureRect.new()
	var cost = RichTextLabel.new()
	var button = TextureButton.new()
	
	var vboxDesc = VBoxContainer.new()
	var rect_desc = TextureRect.new()
	var content_description = VBoxContainer.new()
	var description = RichTextLabel.new()
	
	bat_name.add_theme_font_override("normal_font", MINECRAFT_FONT)
	cost.add_theme_font_override("normal_font", MINECRAFT_FONT)
	description.add_theme_font_override("normal_font", MINECRAFT_FONT)

	# Récupérer les informations via GlobalScript
	var price = GlobalScript.get_building_price(building_name)

	# Assurez-vous que info_array[3] est le name traduit, et info_array[2] est la description
	var translated_name = GlobalScript.get_building_display_name(building_name)
	var description_text = GlobalScript.get_building_description(building_name)
	
	vboxBat.custom_minimum_size = Vector2(512, 300)
	
	separator.color = Color(255, 255, 255)
	separator.custom_minimum_size = Vector2(0, 2)
	
	bat_name.bbcode_enabled = true
	bat_name.bbcode_text = "[center][font_size=48]" + translated_name
	bat_name.fit_content = true
	
	var path = "res://assets/buildings/" + building_name + ".png"
	image.texture = load(path)
	image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	image.custom_minimum_size = Vector2(300, 290)
	
	cost.bbcode_enabled = true
	var hex = "00D900"
	cost.bbcode_text = "[center][font_size=48][color=#" + hex + "]" + GlobalScript.format_money(price) + " €[/color][/font_size]\n[font_size=4] "
	cost.fit_content = true
	
	button.texture_normal = preload("res://assets/button/shop_button/shop_button.png")
	button.texture_hover = preload("res://assets/button/shop_button/shop_button_hover.png")
	button.texture_pressed = preload("res://assets/button/shop_button/shop_button_click.png")
	button.size = Vector2(80, 80)
	button.scale = Vector2(0.9, 0.9)
	button.stretch_mode = TextureButton.STRETCH_SCALE
	button.layout_direction = Control.LAYOUT_DIRECTION_RTL
	
	button.connect("pressed",buy_building.bind(building_name))
	
	cost.add_child(button)
	
	
	vboxDesc.custom_minimum_size = Vector2(510, 300)
	
	content_description.add_theme_constant_override("separation", 10)
	
	rect_desc.texture = preload("res://assets/background/popup_background.png")
	rect_desc.custom_minimum_size = Vector2(0, 400)
	rect_desc.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	
	description.bbcode_enabled = true
	description.custom_minimum_size = Vector2(450, 0)
	description.bbcode_text = "[font_size=26]\n[/font_size][center][font_size=48]DESCRIPTION[/font_size]\n[font_size=32]" + description_text
	description.fit_content = true
	
	content_description.add_child(description)
	
	var health = TextureRect.new()
	health.texture = preload("res://assets/bar/health_icon.png")
	health.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	health.custom_minimum_size = Vector2(50, 50)
	health.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN 
	health.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	
	content_description.add_child(health)

	var efficiency = TextureRect.new()
	efficiency.texture = preload("res://assets/bar/efficiency_icon.png")
	efficiency.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	efficiency.custom_minimum_size = Vector2(50, 50)
	efficiency.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN 
	efficiency.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	
	content_description.add_child(efficiency)

	
	var hapiness = TextureRect.new()
	hapiness.texture = preload("res://assets/bar/happiness_icon.png")
	hapiness.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	hapiness.custom_minimum_size = Vector2(50, 50)
	hapiness.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN 
	hapiness.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	
	content_description.add_child(hapiness)
	
	
	rect_desc.add_child(content_description)
	
	content_description.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT, Control.PRESET_MODE_MINSIZE, 20)
	
	
	vboxDesc.add_child(rect_desc)
	
	vboxBat.add_child(separator)
	vboxBat.add_child(bat_name)
	vboxBat.add_child(image)
	vboxBat.add_child(cost)
	
	buildings_container.add_child(vboxBat)
	buildings_container.add_child(vboxDesc)

func _on_exit_button_pressed() -> void:
	var play_scene = get_tree().current_scene
	var hud = play_scene.get_node("hud")

	if hud.has_node("Shop"):
		hud.get_node("Shop").visible = false


func buy_building(building_name):
	var arbre_scene = load("res://View/buy_confirmation.tscn")
	var play_scene = get_tree().current_scene
	var hud = play_scene.get_node("hud") 

	if not hud.has_node("BuyConfirmation"):
		var instance = arbre_scene.instantiate()
		instance.name = "BuyConfirmation"
		instance.building = building_name
		hud.add_child(instance)

	else:
		var node = hud.get_node("BuyConfirmation")
		node.visible = !node.visible  
