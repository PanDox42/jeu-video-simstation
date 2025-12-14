extends Control

@onready var argent_label = $CanvasLayer/BorderContainer/background/argent
@onready var date_label = $CanvasLayer/BorderContainer/background/mois
@onready var temperature_label = $CanvasLayer/BorderContainer/background/temperature
@onready var saison_label = $CanvasLayer/BorderContainer/background/saison
@onready var chart_stats = $CanvasLayer/BorderContainer/ChartStats
@onready var night_mode = $CanvasLayer/BorderContainer/NightMode
@onready var background = $CanvasLayer/BorderContainer/TopBorder
@onready var inventory = $CanvasLayer/BorderContainer/Inventaire
@onready var close_button = $CanvasLayer/BorderContainer/Close_Inventory

const BACKGROUND_TEXTURE_WITH = preload("res://assets/background/background.png")
const BACKGROUND_TEXTURE_WITHOUT = preload("res://assets/background/background_without_inventory.png")


func _ready():
	chart_stats.hide()
	GlobalScript.connect("argent_changed", Callable(self, "_on_argent_changed"))
	GlobalScript.connect("tour_change", Callable(self, "_maj_saison"))
	GlobalScript.connect("tour_change", Callable(self, "_maj_mois"))
	_maj_mois()
	_maj_saison()
	_maj_temperature()
	_on_argent_changed(GlobalScript.get_argent())
	
func _maj_mois():
	var tour = GlobalScript.get_tour()
	date_label.text = "[center][font_size=24]Mois "+str(tour*3)
	
func _maj_saison():
	saison_label.text = "[center][font_size=24]" + str(Global.environnement["saison"])
	
func _maj_temperature():
	temperature_label.text = "[center][font_size=24]" + str(Global.environnement["temperature"]) + " C°"
	
func _on_argent_changed(new_value):
	if argent_label:
		argent_label.bbcode_text = "[right][font_size=32]" + GlobalScript.format_money(new_value) + " €"

func _maj_night_mode():
	if GlobalScript.get_tour() % 2 == 0:
		night_mode.visible = !night_mode.visible
		

func _on_passer_tour_pressed():
	CalculStats.passer_tour()
	_maj_temperature()
	_maj_night_mode()
	GlobalScript.emit_signal("tour_change")

func _on_btn_graphique_stats_pressed() -> void:
	chart_stats.show()
	#GameManager.load_scene("res://View/chart_stats.tscn", "CharStats")

func _on_fermer_pressed_close_inventory() -> void:
	if inventory.visible:
		background.texture = BACKGROUND_TEXTURE_WITHOUT
		
		close_button.texture_normal = preload("res://assets/button/eyes_button/close_eye/close_eye_button.png")
		close_button.texture_hover = preload("res://assets/button/eyes_button/close_eye/close_eye_button_hover.png")
		close_button.texture_pressed = preload("res://assets/button/eyes_button/close_eye/close_eye_button_click.png")
		
	else :
		background.texture = BACKGROUND_TEXTURE_WITH
		
		close_button.texture_normal = preload("res://assets/button/eyes_button/open_eye/open_eye_button.png")
		close_button.texture_hover = preload("res://assets/button/eyes_button/open_eye/open_eye_button_hover.png")
		close_button.texture_pressed = preload("res://assets/button/eyes_button/open_eye/open_eye_button_click.png")
		
	inventory.visible = !inventory.visible
	
