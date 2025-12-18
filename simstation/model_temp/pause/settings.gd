extends CanvasLayer

@onready var music_slider = $TRectBackground/VBoxParametres/VBoxVolumeMusics/SliderMusics
@onready var effet_slider = $TRectBackground/VBoxParametres/VBoxVolumeSounds/SliderSounds
@onready var screen_button = $TRectBackground/VBoxParametres/ButtonFullScreen

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

func _on_musique_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))

func _on_effet_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"), linear_to_db(value))

func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_reround_button_pressed() -> void:
	#get_tree().paused = false
	queue_free() 
