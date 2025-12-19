## HUD - Interface principale du jeu
##
## Gère l'affichage de toutes les informations principales : argent, date, saison, température.
## Contrôle le bouton suivant pour passer au tour suivant avec cooldown de 15 secondes.
## Gère l'affichage/masquage de l'inventaire, le mode nuit/jour et les notifications de catastrophe.
extends CanvasLayer

## Conteneur principal du HUD
@onready var hud = $BorderContainer

## Label affichant l'argent
@onready var label_money = $BorderContainer/PanelTopBar/RLabelMoney

## Label affichant la date (mois)
@onready var label_date = $BorderContainer/PanelTopBar/RLabelMonth

## Label affichant la température
@onready var label_temperature = $BorderContainer/PanelTopBar/RLabelTemperature

## Label affichant la saison
@onready var label_season = $BorderContainer/PanelTopBar/RLabelSeason

## Panneau du graphique de statistiques
@onready var panel_chart_stats = $BorderContainer/PanelChartStats


@onready var clayer_chart_stats = $BorderContainer/CLayerChartStats

## Filtre sombre pour le mode nuit
@onready var panel_night_mode = $BorderContainer/PanelNightMode

## Image de fond (change selon visibilité inventaire)
@onready var background = $BorderContainer/TRectHudBorder

## Panneau de l'inventaire
@onready var inventory = $BorderContainer/PanelInventory

## Bouton pour afficher/masquer l'inventaire (œil)
@onready var close_button = $BorderContainer/TButtonCloseInventory

## Bouton pour afficher les statistiques
@onready var stats_button = $BorderContainer/TButtonStatistics

## Popup de confirmation pour passer au tour suivant
@onready var confirmation_next_round = $BorderContainer/TRectConfirmNextRound

## Écran de chargement
@onready var load_screen = $LoadScreen

## Panneau de transition entre les tours
@onready var next_round = $BorderContainer/TRectRoundTransition

## Panneau d'affichage des catastrophes
@onready var panel_disaster = $BorderContainer/TRectDisasterPanel

## Indicateur jour/nuit
@onready var night_day = $BorderContainer/TRectRoundTransition/TRectDayNightIndicator

## Bouton pour passer au tour suivant
@onready var btn_next_round = $BorderContainer/TButtonNextRound

## Label affichant le temps de cooldown
@onready var lbl_cooldown = $BorderContainer/TButtonNextRound/RLabelCooldown

## Indique si le bouton est en cooldown
@onready var btn_next_round_reload = true

## Son joué lors du passage au tour suivant
const ROUND_SOUND = "res://assets/sounds/hud/next_round.mp3"

## Son joué lors du masquage de l'inventaire
const HIDE_INVENTORY_SOUND = "res://assets/sounds/hud/hide_inventory.mp3"

## Son joué lors de l'affichage d'une catastrophe
const DISASTER_DISPLAY_SOUND = "res://assets/sounds/hud/disaster_display.mp3"


## Texture de fond avec inventaire visible
const BACKGROUND_TEXTURE_WITH = preload("res://assets/hud/hud_border/border.png"))

## Texture de fond sans inventaire
const BACKGROUND_TEXTURE_WITHOUT = preload("res://assets/hud/hud_border/border_without_inventory.png")

## Initialise le HUD et connecte les signaux
func _ready():
	GlobalScript.connect("money_changed", Callable(self, "_on_money_changed"))
	GlobalScript.connect("round_changed", Callable(self, "_update_season"))
	GlobalScript.connect("round_changed", Callable(self, "_update_month"))
	
	display_next_round()
	panel_chart_stats.hide()
	_update_month()
	_update_season()
	display_night_filter(GlobalScript.get_night_mode())
	_update_temperature()
	_on_money_changed(GlobalScript.get_money())
	
	btn_next_round_start_cooldown()

## Met à jour l'affichage du mois
func _update_month():
	var round = GlobalScript.get_round()
	label_date.text = "[center][font_size=24]Mois %d" % (round * 3)

## Met à jour l'affichage de la saison
func _update_season():
	label_season.text = "[center][font_size=24]%s" % GlobalScript.get_environnement("season")

## Met à jour l'affichage de la température
func _update_temperature():
	label_temperature.text = "[center][font_size=24]%d C°" % GlobalScript.get_environnement("temperature")

## Met à jour l'affichage de l'argent
## @param new_value: Nouvelle valeur de l'argent
func _on_money_changed(new_value):
	if label_money:
		label_money.bbcode_text = "[right][font_size=32]%s €" % GlobalScript.format_money(new_value)

## Bascule le mode nuit tous les 2 tours
func _update_night_mode():
	if GlobalScript.get_round() % 2 == 0 && GlobalScript.get_round() != 0:
		night_day.visible = true
		
		var status = !GlobalScript.get_night_mode()
		GlobalScript.set_night_mode(status)
		
		display_night_filter(status)
		display_night_day(status)
	else :
		night_day.visible = false

## Appelé quand le bouton "Tour suivant" est pressé
func _on_next_round_pressed():
	change_visible_confirmation_next_round()
	
	CalculStats.next_round()
	display_next_round()
	_update_temperature()
	_update_night_mode()
	
	btn_next_round_start_cooldown()
	
	display_disaster()	

## Bascule la visibilité du popup de confirmation
func change_visible_confirmation_next_round() -> void:
	btn_next_round.release_focus()
	
	if btn_next_round_reload :
		lbl_cooldown.visible = true
		return
	confirmation_next_round.visible = !confirmation_next_round.visible

## Démarre le cooldown de 15 secondes sur le bouton "Tour suivant"
func btn_next_round_start_cooldown():
	btn_next_round.modulate.a = 0.5
	btn_next_round_reload = true
	
	await get_tree().create_timer(15.0).timeout
	
	btn_next_round.modulate.a = 1.0
	lbl_cooldown.visible = false
	btn_next_round_reload = false


## Ouvre le graphique de statistiques
func _on_btn_chart_stats_pressed() -> void:
	stats_button.release_focus()
	change_visible_chart_stats()
	#GameManager.load_scene("res://View/clayer_chart_stats.tscn", "CharStats")

## Bascule la visibilité de l'inventaire et change l'icône de l'œil
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

## Cache l'écran de chargement après 1 seconde
func charger_load_screen():
	await get_tree().create_timer(1).timeout
	load_screen.visible = false


## Affiche l'animation de transition de tour
func display_next_round() :
	close_button.release_focus()
	GlobalScript.play_sound(ROUND_SOUND)
	
	var round = next_round.get_child(0)
	round.bbcode_text = "[center][font_size=56]Tour %d" % (GlobalScript.get_round() + 1)
	
	GlobalScript.generate_fade_display(0.5, 0.5, 5, next_round)

## Affiche ou masque le filtre de nuit avec animation
## @param status: true pour afficher, false pour masquer
func display_night_filter(status : bool) :
	var tween = create_tween()
	
	if status : 
		panel_night_mode.visible = status
		tween.tween_property(panel_night_mode, "modulate:a", 1.0, 1)
	else :
		tween.tween_property(panel_night_mode, "modulate:a", 0.0, 1)
		tween.tween_callback(func(): panel_night_mode.visible = status)

## Affiche le message "La nuit tombe" ou "Le jour se lève"
## @param status: true pour nuit, false pour jour
func display_night_day(status : bool):
	if status:
		night_day.get_child(0).bbcode_text = "[center][font_size=24]La nuit tombe"
	else :
		night_day.get_child(0).bbcode_text = "[center][font_size=24]Le jour se lève"
		
	night_day.visible = true
	await get_tree().create_timer(7).timeout
	night_day.visible = false

## Change la visibilité du panel des statistiques
func change_visible_chart_stats():
	panel_chart_stats.visible = !panel_chart_stats.visible


## Affiche la notification de catastrophe si une est active
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
