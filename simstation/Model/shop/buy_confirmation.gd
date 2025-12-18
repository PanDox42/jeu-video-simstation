extends CanvasLayer

@onready var message_label = $TRectBackground/RLabelMessage
@onready var confirm_button = $"TRectBackground/TButtonConfirm"

@onready var purchase_sound = "res://assets/sounds/shop/purchase.mp3"

@onready var price = GlobalScript.get_building_price(building)
@onready var money = GlobalScript.get_money()
@onready var money_required = GlobalScript.get_building_price(building)
@onready var building_name = GlobalScript.get_building_display_name(building)

const PURCHASE_SOUND = "res://assets/sounds/shop/purchase.mp3"

var building = ""


func _ready():
	if money >= money_required :
		message_label.bbcode_text = "[center][font_size=32]Voulez-vous vraiment acheter le batiment : %s ?" % building_name
	else :
		confirm_button.visible = false
		message_label.bbcode_text = "[center][font_size=32]Vous n'avez pas assez d'money pour le batiment : %s\n" % building_name
		message_label.add_theme_color_override("default_color", "d86700")
		

func _on_confirm_button_pressed() -> void:
	GlobalScript.play_sound(PURCHASE_SOUND)
	
	GlobalScript.edit_money(-price)
	GlobalScript.edit_building(building, 1)
	self.queue_free()

func _on_cancel_button_pressed() -> void:
	self.queue_free()
