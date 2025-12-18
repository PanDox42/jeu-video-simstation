extends CanvasLayer

@onready var message_label = $TRectBackground/RLabelMessage
@onready var confirm_button = $"TRectBackground/TButtonConfirm"

@onready var purchase_sound = "res://assets/sounds/shop/purchase.mp3"

@onready var prix = GlobalScript.get_batiment_prix(batiment)
@onready var argent = GlobalScript.get_argent()
@onready var argent_requis = GlobalScript.get_batiment_prix(batiment)
@onready var building_name = GlobalScript.get_batiment_real_name(batiment)

const PURCHASE_SOUND = "res://assets/sounds/shop/purchase.mp3"

var batiment = ""


func _ready():
	if argent >= argent_requis :
		message_label.bbcode_text = "[center][font_size=32]Voulez-vous vraiment acheter le batiment : %s ?" % building_name
	else :
		confirm_button.visible = false
		message_label.bbcode_text = "[center][font_size=32]Vous n'avez pas assez d'argent pour le batiment : %s\n" % building_name
		message_label.add_theme_color_override("default_color", "d86700")
		

func _on_confirm_button_pressed() -> void:
	GlobalScript.play_sound(PURCHASE_SOUND)
	
	GlobalScript.modifier_argent(-prix)
	GlobalScript.modifier_batiment(batiment, 1)
	self.queue_free()

func _on_cancel_button_pressed() -> void:
	self.queue_free()
