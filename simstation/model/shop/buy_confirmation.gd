## BuyConfirmation - Fenêtre de confirmation d'achat
##
## Popup de confirmation affiché avant l'achat d'un bâtiment.
## Vérifie que le joueur a suffisamment d'argent et affiche un message approprié.
## Gère la transaction (débit de l'argent et ajout du bâtiment à l'inventaire).
extends CanvasLayer

## Label affichant le message de confirmation ou d'erreur
@onready var message_label = $TRectBackground/RLabelMessage

## Bouton de confirmation d'achat
@onready var confirm_button = $"TRectBackground/TButtonConfirm"

## Chemin du son de confirmation d'achat
@onready var purchase_sound = "res://assets/sounds/shop/purchase.mp3"

## Prix du bâtiment à acheter
@onready var price = GlobalScript.get_building_price(building)

## Argent disponible du joueur
@onready var money = GlobalScript.get_money()

## Argent requis pour l'achat
@onready var money_required = GlobalScript.get_building_price(building)

## Nom d'affichage du bâtiment
@onready var building_name = GlobalScript.get_building_display_name(building)

## Constante pour le son d'achat
const PURCHASE_SOUND = "res://assets/sounds/shop/purchase.mp3"

## Nom interne du bâtiment à acheter (défini depuis shop.gd)
var building = ""


## Initialise le popup avec le message approprié
## Affiche soit la confirmation, soit un message d'erreur si pas assez d'argent
func _ready():
	if money >= money_required :
		message_label.bbcode_text = "[center][font_size=32]Voulez-vous vraiment acheter le batiment : %s ?" % building_name
	else :
		confirm_button.visible = false
		message_label.bbcode_text = "[center][font_size=32][color=orange]Vous n'avez pas assez d'argent pour le batiment : %s\n" % building_name
		
## Confirme l'achat du bâtiment
## Débite l'argent, ajoute le bâtiment à l'inventaire et joue le son d'achat
func _on_confirm_button_pressed() -> void:
	GlobalScript.play_sound(PURCHASE_SOUND)
	
	GlobalScript.edit_money(-price)
	GlobalScript.edit_building(building, 1)
	self.queue_free()

## Annule l'achat et ferme le popup
func _on_cancel_button_pressed() -> void:
	self.queue_free()
