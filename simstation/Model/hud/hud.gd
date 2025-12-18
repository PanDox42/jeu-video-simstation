extends CanvasLayer

@onready var hud = $BorderContainer
@onready var argent_label = $BorderContainer/PanelTopBar/RLabelMoney
@onready var date_label = $BorderContainer/PanelTopBar/RLabelMonth
@onready var temperature_label = $BorderContainer/PanelTopBar/RLabelTemperature
@onready var saison_label = $BorderContainer/PanelTopBar/RLabelSeason
@onready var chart_stats = $BorderContainer/CLayerChartStats
@onready var night_mode = $BorderContainer/PanelNightMode
@onready var background = $BorderContainer/TRectHudBorder
@onready var inventory = $BorderContainer/PanelInventory
@onready var close_button = $BorderContainer/TButtonCloseInventory
@onready var confirmation_passer_tour = $BorderContainer/PanelConfirmNextRound
@onready var load_screen = $LoadScreen
@onready var changement_tour = $BorderContainer/TRectRoundTransition
@onready var panel_catastrophe = $BorderContainer/TRectDisasterPanel
@onready var nuit_jour = $BorderContainer/TRectRoundTransition/TRectDayNightIndicator
@onready var btn_next_round = $BorderContainer/TButtonNextRound
@onready var lbl_cooldown = $BorderContainer/TButtonNextRound/RLabelCooldown
@onready var btn_next_round_reload = true

const ROUND_SOUND = "res://assets/sounds/hud/next_round.mp3"
const HIDE_INVENTORY_SOUND = "res://assets/sounds/hud/hide_inventory.mp3"
const DISASTER_DISPLAY_SOUND = "res://assets/sounds/hud/disaster_display.mp3"

const BACKGROUND_TEXTURE_WITH = preload("res://assets/background/background.png")
const BACKGROUND_TEXTURE_WITHOUT = preload("res://assets/background/background_without_inventory.png")


func _ready():
	GlobalScript.connect("argent_changed", Callable(self, "_on_argent_changed"))
	GlobalScript.connect("tour_change", Callable(self, "_maj_saison"))
	GlobalScript.connect("tour_change", Callable(self, "_maj_mois"))
	
	afficher_changement_tour()
	chart_stats.hide()
	_maj_mois()
	_maj_saison()
	afficher_filtre_nuit(GlobalScript.get_night_mode())
	_maj_temperature()
	_on_argent_changed(GlobalScript.get_argent())
	
	btn_next_round_start_cooldown()
	
	
func _maj_mois():
	var tour = GlobalScript.get_tour()
	date_label.text = "[center][font_size=24]Mois %d" % (tour * 3)
	
func _maj_saison():
	saison_label.text = "[center][font_size=24]%s" % GlobalScript.get_environnement("saison")
	
func _maj_temperature():
	temperature_label.text = "[center][font_size=24]%d C°" % GlobalScript.get_environnement("temperature")
	
func _on_argent_changed(new_value):
	if argent_label:
		argent_label.bbcode_text = "[right][font_size=32]%s €" % GlobalScript.format_money(new_value)

func _maj_night_mode():
	if GlobalScript.get_tour() % 2 == 0 && GlobalScript.get_tour() != 0:
		nuit_jour.visible = true
		
		var status = !GlobalScript.get_night_mode()
		GlobalScript.set_night_mode(status)
		
		afficher_filtre_nuit(status)
		afficher_nuit_jour(status)
	else :
		nuit_jour.visible = false

	

func _on_passer_tour_pressed():
	change_visible_confirmation_passer_tour()
	
	CalculStats.passer_tour()
	afficher_changement_tour()
	_maj_temperature()
	_maj_night_mode()
	
	btn_next_round_start_cooldown()
	
	afficher_catastrophe()	
	
func change_visible_confirmation_passer_tour() -> void:
	btn_next_round.release_focus()
	
	if btn_next_round_reload :
		lbl_cooldown.visible = true
		return
	confirmation_passer_tour.visible = !confirmation_passer_tour.visible
	
func btn_next_round_start_cooldown():
	btn_next_round.modulate.a = 0.5
	btn_next_round_reload = true
	
	await get_tree().create_timer(15.0).timeout
	
	btn_next_round.modulate.a = 1.0
	lbl_cooldown.visible = false
	btn_next_round_reload = false


func _on_btn_graphique_stats_pressed() -> void:
	chart_stats.show()
	#GameManager.load_scene("res://View/chart_stats.tscn", "CharStats")

func _on_fermer_pressed_close_inventory() -> void:
	close_button.release_focus()
	
	GlobalScript.play_sound(HIDE_INVENTORY_SOUND)
	
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
	
	

func charger_load_screen():
	await get_tree().create_timer(1).timeout
	load_screen.visible = false


func afficher_changement_tour() :
	GlobalScript.play_sound(ROUND_SOUND)
	
	var tour = changement_tour.get_child(0)
	tour.bbcode_text = "[center][font_size=56]Tour %d" % (GlobalScript.get_tour() + 1)
	
	GlobalScript.generate_fade_display(0.5, 0.5, 5, changement_tour)
	
	
func afficher_filtre_nuit(status : bool) :
	var tween = create_tween()
	
	if status : 
		night_mode.visible = status
		tween.tween_property(night_mode, "modulate:a", 1.0, 1)
	else :
		tween.tween_property(night_mode, "modulate:a", 0.0, 1)
		tween.tween_callback(func(): night_mode.visible = status)
	
	
func afficher_nuit_jour(status : bool):
	if status:
		nuit_jour.get_child(0).bbcode_text = "[center][font_size=24]La nuit tombe"
	else :
		nuit_jour.get_child(0).bbcode_text = "[center][font_size=24]Le jour se lève"
		
	nuit_jour.visible = true
	await get_tree().create_timer(7).timeout
	nuit_jour.visible = false


func afficher_catastrophe():
	var catastrophe = Catastrophes.get_catastrophe_active()
	
	if catastrophe != null:
		await get_tree().create_timer(3).timeout
		
		GlobalScript.play_sound(DISASTER_DISPLAY_SOUND)
		
		var panel = panel_catastrophe
		
		var info = catastrophe["info"]
		var nom = info[4]
		var description = info[5]
		
		var text = "[center][font_size=36][color=red]%s\n" % nom
		text += "[font_size=12] [font_size=24][color=white]%s" % description
		
		panel.get_child(0).bbcode_text = text
		
		GlobalScript.generate_fade_display(0, 1, 10, panel)
	
