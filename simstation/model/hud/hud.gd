extends CanvasLayer

@onready var hud = $BorderContainer
@onready var label_money = $BorderContainer/PanelTopBar/RLabelMoney
@onready var label_date = $BorderContainer/PanelTopBar/RLabelMonth
@onready var label_temperature = $BorderContainer/PanelTopBar/RLabelTemperature
@onready var label_season = $BorderContainer/PanelTopBar/RLabelSeason
@onready var clayer_chart_stats = $BorderContainer/CLayerChartStats
@onready var panel_night_mode = $BorderContainer/PanelNightMode
@onready var background = $BorderContainer/TRectHudBorder
@onready var inventory = $BorderContainer/PanelInventory
@onready var close_button = $BorderContainer/TButtonCloseInventory
@onready var stats_button = $BorderContainer/TButtonStatistics
@onready var confirmation_next_round = $BorderContainer/PanelConfirmNextRound
@onready var load_screen = $LoadScreen
@onready var next_round = $BorderContainer/TRectRoundTransition
@onready var panel_disaster = $BorderContainer/TRectDisasterPanel
@onready var night_day = $BorderContainer/TRectRoundTransition/TRectDayNightIndicator
@onready var btn_next_round = $BorderContainer/TButtonNextRound
@onready var lbl_cooldown = $BorderContainer/TButtonNextRound/RLabelCooldown
@onready var btn_next_round_reload = true

const ROUND_SOUND = "res://assets/sounds/hud/next_round.mp3"
const HIDE_INVENTORY_SOUND = "res://assets/sounds/hud/hide_inventory.mp3"
const DISASTER_DISPLAY_SOUND = "res://assets/sounds/hud/disaster_display.mp3"

const BACKGROUND_TEXTURE_WITH = preload("res://assets/background/background.png")
const BACKGROUND_TEXTURE_WITHOUT = preload("res://assets/background/background_without_inventory.png")


func _ready():
	GlobalScript.connect("money_changed", Callable(self, "_on_money_changed"))
	GlobalScript.connect("round_changed", Callable(self, "_update_season"))
	GlobalScript.connect("round_changed", Callable(self, "_update_month"))
	
	display_next_round()
	clayer_chart_stats.hide()
	_update_month()
	_update_season()
	display_night_filter(GlobalScript.get_night_mode())
	_update_temperature()
	_on_money_changed(GlobalScript.get_money())
	
	btn_next_round_start_cooldown()
	
	
func _update_month():
	var round = GlobalScript.get_round()
	label_date.text = "[center][font_size=24]Mois %d" % (round * 3)
	
func _update_season():
	label_season.text = "[center][font_size=24]%s" % GlobalScript.get_environnement("season")
	
func _update_temperature():
	label_temperature.text = "[center][font_size=24]%d C°" % GlobalScript.get_environnement("temperature")
	
func _on_money_changed(new_value):
	if label_money:
		label_money.bbcode_text = "[right][font_size=32]%s €" % GlobalScript.format_money(new_value)

func _update_night_mode():
	if GlobalScript.get_round() % 2 == 0 && GlobalScript.get_round() != 0:
		night_day.visible = true
		
		var status = !GlobalScript.get_night_mode()
		GlobalScript.set_night_mode(status)
		
		display_night_filter(status)
		display_night_day(status)
	else :
		night_day.visible = false

	

func _on_next_round_pressed():
	change_visible_confirmation_next_round()
	
	CalculStats.next_round()
	display_next_round()
	_update_temperature()
	_update_night_mode()
	
	btn_next_round_start_cooldown()
	
	display_disaster()	
	
func change_visible_confirmation_next_round() -> void:
	btn_next_round.release_focus()
	
	if btn_next_round_reload :
		lbl_cooldown.visible = true
		return
	confirmation_next_round.visible = !confirmation_next_round.visible
	
func btn_next_round_start_cooldown():
	btn_next_round.modulate.a = 0.5
	btn_next_round_reload = true
	
	await get_tree().create_timer(15.0).timeout
	
	btn_next_round.modulate.a = 1.0
	lbl_cooldown.visible = false
	btn_next_round_reload = false


func _on_btn_chart_stats_pressed() -> void:
	stats_button.release_focus()
	clayer_chart_stats.show()
	#GameManager.load_scene("res://View/clayer_chart_stats.tscn", "CharStats")

func _on_close_inventory_pressed_() -> void:
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


func display_next_round() :
	close_button.release_focus()
	GlobalScript.play_sound(ROUND_SOUND)
	
	var round = next_round.get_child(0)
	round.bbcode_text = "[center][font_size=56]Tour %d" % (GlobalScript.get_round() + 1)
	
	GlobalScript.generate_fade_display(0.5, 0.5, 5, next_round)
	
	
func display_night_filter(status : bool) :
	var tween = create_tween()
	
	if status : 
		panel_night_mode.visible = status
		tween.tween_property(panel_night_mode, "modulate:a", 1.0, 1)
	else :
		tween.tween_property(panel_night_mode, "modulate:a", 0.0, 1)
		tween.tween_callback(func(): panel_night_mode.visible = status)
	
	
func display_night_day(status : bool):
	if status:
		night_day.get_child(0).bbcode_text = "[center][font_size=24]La nuit tombe"
	else :
		night_day.get_child(0).bbcode_text = "[center][font_size=24]Le jour se lève"
		
	night_day.visible = true
	await get_tree().create_timer(7).timeout
	night_day.visible = false


func display_disaster():
	var disaster = Catastrophes.get_active_disaster()
	
	if disaster != null:
		await get_tree().create_timer(3).timeout
		
		GlobalScript.play_sound(DISASTER_DISPLAY_SOUND)
		
		var panel = panel_disaster
		
		var info = disaster["info"]
		var name = info[4]
		var description = info[5]
		
		var text = "[center][font_size=36][color=red]%s\n" % name
		text += "[font_size=12] [font_size=24][color=white]%s" % description
		
		panel.get_child(0).bbcode_text = text
		
		GlobalScript.generate_fade_display(0, 1, 10, panel)
	
