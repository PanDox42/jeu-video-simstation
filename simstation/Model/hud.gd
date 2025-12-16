extends CanvasLayer

@onready var argent_label = $BorderContainer/background/argent
@onready var date_label = $BorderContainer/background/mois
@onready var temperature_label = $BorderContainer/background/temperature
@onready var saison_label = $BorderContainer/background/saison
@onready var chart_stats = $BorderContainer/ChartStats
@onready var night_mode = $BorderContainer/NightMode
@onready var background = $BorderContainer/TopBorder
@onready var inventory = $BorderContainer/Inventaire
@onready var close_button = $BorderContainer/Close_Inventory
@onready var confirmation_passer_tour = $BorderContainer/passerTour
@onready var load_screen = $LoadScreen
@onready var changement_tour = $"BorderContainer/PanelChangementTour"
@onready var nuit_jour = $"BorderContainer/PanelNuitJour" 

const BACKGROUND_TEXTURE_WITH = preload("res://assets/background/background.png")
const BACKGROUND_TEXTURE_WITHOUT = preload("res://assets/background/background_without_inventory.png")


func _ready():
	afficher_changement_tour()
	chart_stats.hide()
	GlobalScript.connect("argent_changed", Callable(self, "_on_argent_changed"))
	GlobalScript.connect("tour_change", Callable(self, "_maj_saison"))
	GlobalScript.connect("tour_change", Callable(self, "_maj_mois"))
	_maj_mois()
	_maj_saison()
	_maj_temperature()
	_maj_night_mode()
	_on_argent_changed(GlobalScript.get_argent())
	
func _maj_mois():
	var tour = GlobalScript.get_tour()
	date_label.text = "[center][font_size=24]Mois "+str(tour*3)
	
func _maj_saison():
	saison_label.text = "[center][font_size=24]" + str(GlobalScript.get_environnement("saison"))
	
func _maj_temperature():
	temperature_label.text = "[center][font_size=24]" + str(GlobalScript.get_environnement("temperature")) + " C°"
	
func _on_argent_changed(new_value):
	if argent_label:
		argent_label.bbcode_text = "[right][font_size=32]" + GlobalScript.format_money(new_value) + " €"

func _maj_night_mode():
	if GlobalScript.get_tour() % 2 == 0 && GlobalScript.get_tour() != 0:
		var status = !GlobalScript.get_night_mode()
		
		night_mode.visible = status
		GlobalScript.set_night_mode(status)
		
		afficher_nuit_jour(status)
	

func _on_passer_tour_pressed():
	CalculStats.passer_tour()
	afficher_changement_tour()
	_maj_temperature()
	_maj_night_mode()
	change_visible_confirmation_passer_tour()
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
	


func change_visible_confirmation_passer_tour() -> void:
	confirmation_passer_tour.visible = !confirmation_passer_tour.visible
	
	
func charger_load_screen():
	await get_tree().create_timer(1).timeout
	load_screen.visible = false

func afficher_changement_tour() :
	changement_tour.get_child(0).bbcode_text = "[center][font_size=48]Tour " + str(GlobalScript.get_tour() + 1)
	changement_tour.visible = true
	await get_tree().create_timer(2).timeout
	changement_tour.visible = false
	
func afficher_nuit_jour(status : bool):
	if status:
		nuit_jour.get_child(0).bbcode_text = "[center][font_size=24]La nuit tombe"
	else :
		nuit_jour.get_child(0).bbcode_text = "[center][font_size=24]Le jour se lève"
		
	nuit_jour.visible = true
	await get_tree().create_timer(2).timeout
	nuit_jour.visible = false
