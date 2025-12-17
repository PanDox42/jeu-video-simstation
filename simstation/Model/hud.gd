extends CanvasLayer

@onready var hud = $"BorderContainer"
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
@onready var nuit_jour = $"BorderContainer/PanelChangementTour/PanelNuitJour" 
@onready var btn_next_round = $"BorderContainer/PasserTour" 
@onready var lbl_cooldown = $"BorderContainer/PasserTour/lbl_cooldown"
@onready var btn_next_round_reload = true

@onready var round_sound = "res://assets/sounds/hud/next_round.mp3"
@onready var hide_inventory_sound = "res://assets/sounds/hud/hide_inventory.mp3"

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
	GlobalScript.emit_signal("tour_change")
	
	btn_next_round_start_cooldown()
	
	
func change_visible_confirmation_passer_tour() -> void:
	btn_next_round.release_focus()
	
	if btn_next_round_reload :
		lbl_cooldown.visible = true
		return
	confirmation_passer_tour.visible = !confirmation_passer_tour.visible
	
func btn_next_round_start_cooldown():
	btn_next_round.modulate.a = 0.5
	btn_next_round_reload = true
	await get_tree().create_timer(10.0).timeout
	btn_next_round.modulate.a = 1.0
	lbl_cooldown.visible = false
	btn_next_round_reload = false


func _on_btn_graphique_stats_pressed() -> void:
	chart_stats.show()
	#GameManager.load_scene("res://View/chart_stats.tscn", "CharStats")

func _on_fermer_pressed_close_inventory() -> void:
	GlobalScript.play_sound(hide_inventory_sound)
	
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
	GlobalScript.play_sound(round_sound)
	
	var tour = changement_tour.get_child(0)
	tour.bbcode_text = "[center][font_size=56]Tour " + str(GlobalScript.get_tour() + 1)
	
	changement_tour.modulate.a = 0
	changement_tour.visible = true

	# Création du Tween
	var tween_afficher_tour = create_tween()

	# 1. Apparition (Fade In) en 0.5 seconde
	tween_afficher_tour.tween_property(changement_tour, "modulate:a", 1.0, 0.5)

	# 2. Attendre x secondes
	tween_afficher_tour.tween_interval(5.0)

	# 3. Disparition (Fade Out) en 0.5 seconde
	tween_afficher_tour.tween_property(changement_tour, "modulate:a", 0.0, 0.5)

	# 4. Cacher le nœud à la fin pour la performance
	tween_afficher_tour.tween_callback(func(): changement_tour.visible = false)
	
	
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
	await get_tree().create_timer(2).timeout
	nuit_jour.visible = false

func afficher_catastrophe():
	var catastrophe = Catastrophes.get_catastrophe_active()
	if catastrophe != null:
		var info = catastrophe["info"]
		var nom = info[4]
		var description = info[5]
		
		var panel = changement_tour
		var text = "[center][font_size=36][color=red]" + nom + "\n"
		text += "[font_size=24][color=white]" + description
		
		# Anchors pour étendre le panel
		panel.anchor_left = 0.50
		panel.anchor_right = 0.50
		panel.anchor_top = 0.40
		panel.anchor_bottom = 0.60
		
		panel.get_child(0).bbcode_text = text
		panel.visible = true
		await get_tree().create_timer(8).timeout
		panel.visible = false
		
		# Remettre la taille normale pour l'affichage du tour
		panel.anchor_left = 0.5
		panel.anchor_right = 0.5
		panel.anchor_top = 0.5
		panel.anchor_bottom = 0.5
		panel.custom_minimum_size = Vector2(0, 0)
