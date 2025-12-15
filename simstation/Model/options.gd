extends Control

@onready var music_slider = $background/VBoxContainer/VBoxContainer/Musique_slider
@onready var effet_slider = $background/VBoxContainer/VBoxContainer2/Effet_slider
@onready var ecran_button = $background/VBoxContainer/Pleinecran_button

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	var default_volume_linear = 0.5
	music_slider.value = default_volume_linear
	effet_slider.value = default_volume_linear

	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(default_volume_linear))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(default_volume_linear))
	
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN :
		ecran_button.button_pressed = true
	else :
		ecran_button.button_pressed = false

func _on_musique_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))

func _on_effet_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))

func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_retour_button_pressed() -> void:
	#get_tree().paused = false
	queue_free() 
