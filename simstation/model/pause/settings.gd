## Settings - Menu des paramètres du jeu
##
## Gère les réglages audio (musique, effets sonores) et d'affichage (plein écran).
## Synchronise les sliders avec les volumes des bus audio et gère le mode plein écran.
extends CanvasLayer

## Slider de volume pour la musique
@onready var music_slider = $TRectBackground/VBoxParametres/VBoxVolumeMusics/SliderMusics

## Slider de volume pour les effets sonores
@onready var effet_slider = $TRectBackground/VBoxParametres/VBoxVolumeSounds/SliderSounds

## Bouton de basculement plein écran
@onready var screen_button = $TRectBackground/VBoxParametres/ButtonFullScreen

## Initialise les paramètres avec les valeurs actuelles
## Charge les volumes audio et l'état du mode plein écran dans l'interface
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	var music_volume_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	var sfx_volume_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sound"))
	
	var music_volume_linear = db_to_linear(music_volume_db)
	var sfx_volume_linear = db_to_linear(sfx_volume_db)
	
	music_slider.value = music_volume_linear
	effet_slider.value = sfx_volume_linear

	
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN :
		screen_button.button_pressed = true
	else :
		screen_button.button_pressed = false

## Ajuste le volume de la musique
## @param value: Valeur linéaire du volume (0.0 à 1.0)
func _on_musique_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))

## Ajuste le volume des effets sonores
## @param value: Valeur linéaire du volume (0.0 à 1.0)
func _on_effet_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"), linear_to_db(value))

## Bascule entre mode fenêtré et plein écran
## @param toggled_on: true pour plein écran, false pour fenêtré
func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

## Ferme le menu des paramètres
func _on_reround_button_pressed() -> void:
	#get_tree().paused = false
	queue_free() 
