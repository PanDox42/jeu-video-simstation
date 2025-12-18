extends Node

# DESCRIPTION :
# FLEMME

signal money_changed(new_value)
signal building_changed(batiment_name, new_value)
signal stats_updated() 
signal request_opening_info(building_name)
signal closure_request_info() 
signal round_changed() 
signal unblocked_building()

# GET
func get_health() -> int: return Global.stats["health"]
func get_efficiency() -> int: return Global.stats["efficiency"]
func get_hapiness() -> int: return Global.stats["happiness"]
func get_money() -> int: return Global.money
func get_inventory() -> Dictionary: return Global.inventory
func get_camera() -> bool: return Global.camera_enable

# Gestion du temps / round
func get_round() -> int: return Global.round
func get_temperature() -> int: return Global.environnement["temperature"]

# Gestion Batiments
func get_building_price(name) -> int: return Global.buildings_info[name][4]
func get_info_building(id): 
	var id_int = int(id) 
	if Global.buildings_place.has(id_int):
		return Global.buildings_place[id_int]
	return null
func get_buildings_counts() -> int: return Global.buildings_place.size()
func get_buildings_place() -> Dictionary: return Global.buildings_place
func get_buildings_data() -> Dictionary: return Global.buildings_info
func get_buildings_unblocked(building_name) -> bool: return Global.buildings_info[building_name][3]
func get_building_hapiness(building_name) : return Global.buildings_info[building_name][0]
func get_building_description(building_name) : return Global.buildings_info[building_name][1]
func get_population() -> Array: return Global.population
func get_building_inventory(nameBat) -> int: return Global.inventory[nameBat]
func get_research_in_progress() -> Dictionary: return Global.research_in_progress
func get_search_unblocked() -> Array: return Global.search_unblocked

func get_environnement(environnement): return Global.environnement[environnement]
func get_night_mode() : return Global.environnement["night"]
func get_currently_placing(): return Global.currently_placing
func get_building_display_name(building_name): return Global.buildings_info[building_name][2]
func get_building_false_name_by_id(building_id): return Global.buildings_place[building_id][0]

func get_size_building(building_name): return Global.buildings_info[building_name][5]

# SET

func set_health(val): Global.stats["health"] = val
func set_efficiency(val): Global.stats["efficiency"] = val
func set_hapiness(val): Global.stats["happiness"] = val
func set_money(val): Global.money = val
func set_camera(val): Global.camera_enable = val

func set_night_mode(active : bool) : Global.environnement["night"] = active

func set_round(val: int):
	Global.round = val
	
func set_temperature(val: int):
	Global.environnement["temperature"] = val
	
func set_research_in_progress(search_name, end_round):
	Global.research_in_progress[search_name] = end_round
	
func set_building_unblocked(name: String):
	Global.buildings_info[name][3] = true;
	
func set_season(saison : String) :
	Global.environnement["season"] = saison
	
func set_currently_placing(placing: bool):
	Global.currently_placing = placing
	
# ADD

func add_search_unblocked(search_name):
	Global.search_unblocked.append(search_name) 
	
func ass_research_in_progress(search_name):
	Global.research_in_progress.append(search_name) 

func add_building(id_node: int, type: String):
	var id_int = int(id_node)
	Global.buildings_place[id_int] = {
		"type": type, 
		"temp": 18, 
		"health": 100
	}
	
# ERASE

func erase_research_in_progress(search_name):
	Global.research_in_progress.erase(search_name) 

# AUTRE

func has_search(name: String) -> bool:
	return Global.search_unblocked.has(name)
	
func edit_money(delta: int) -> void:
	set_money(get_money() + delta)
	emit_signal("money_changed", get_money())

func edit_building(name: String, delta: int) -> void:
	var inventory = get_inventory()
	if inventory.has(name):
		inventory[name] += delta
		emit_signal("building_changed", name, inventory[name])

func update_population_stats(health: float, hapiness: float, efficiency: float) -> void:
	for habitant in Global.population:
		habitant["health"] = lerp(float(habitant["health"]), health, 0.8) 
		habitant["happiness"] = lerp(float(habitant["happiness"]), hapiness, 0.8)
		habitant["efficiency"] = efficiency
	emit_signal("stats_updated")

func format_money(value: int) -> String:
	var s = str(value)
	var result = ""
	var count = 0
	for i in range(s.length() - 1, -1, -1):
		result = s[i] + result
		count += 1
		if count % 3 == 0 and i != 0:
			result = " " + result
	return result
	
	
func play_sound(sound_path: String):
	var sound = AudioStreamPlayer.new()
	var stream = load(sound_path)
	
	if not stream:
		print("Erreur : Impossible de trouver le son : ", sound_path)
		return
		
	sound.stream = stream
	sound.bus = "Sound"

	add_child(sound)

	sound.play()
	sound.finished.connect(sound.queue_free)

func generate_fade_display(start_fade_time, end_fade_time, display_time, element):
	element.modulate.a = 0
	element.visible = true
	
	# Création du Tween
	var tween = create_tween()

	# 1. Apparition en start_fade_time seconde
	tween.tween_property(element, "modulate:a", 1.0, start_fade_time)
	
	# 2. Attendre display_time secondes
	tween.tween_interval(display_time)
	
	# 3. Disparition en end_fade_time seconde
	tween.tween_property(element, "modulate:a", 0.0, end_fade_time)
	
	# 4. Cacher le nœud à la fin pour la performance
	tween.tween_callback(func(): element.visible = false)
