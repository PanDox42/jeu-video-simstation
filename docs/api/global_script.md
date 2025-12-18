# global_script

**Extends:** `Node`

**Fichier:** `model\global\global_script.gd`

## Variables

### id_int

### id_int

### inventory

### s

### result

### count

### sound

### stream

### tween

## Fonctions

### get_health() -> int

### get_efficiency() -> int

### get_hapiness() -> int

### get_money() -> int

### get_inventory() -> Dictionary

### get_camera() -> bool

### get_round() -> int

### get_temperature() -> int

### get_building_price(name) -> int

### get_info_building(id)

### get_buildings_counts() -> int

### get_buildings_place() -> Dictionary

### get_buildings_data() -> Dictionary

### get_buildings_unblocked(building_name) -> bool

### get_building_hapiness(building_name)

### get_building_description(building_name)

### get_population() -> Array

### get_building_inventory(nameBat) -> int

### get_research_in_progress() -> Dictionary

### get_search_unblocked() -> Array

### get_environnement(environnement)

### get_night_mode()

### get_currently_placing()

### get_building_display_name(building_name)

### get_building_false_name_by_id(building_id)

### get_size_building(building_name)

### set_health(val)

### set_efficiency(val)

### set_hapiness(val)

### set_money(val)

### set_camera(val)

### set_night_mode(active : bool)

### set_round(val: int)

### set_temperature(val: int)

### set_research_in_progress(search_name, end_round)

### set_building_unblocked(name: String)

### set_season(saison : String)

### set_currently_placing(placing: bool)

### add_search_unblocked(search_name)

### ass_research_in_progress(search_name)

### add_building(id_node: int, type: String)

### erase_research_in_progress(search_name)

### has_search(name: String) -> bool

### edit_money(delta: int) -> void

### edit_building(name: String, delta: int) -> void

### update_population_stats(health: float, hapiness: float, efficiency: float) -> void

### format_money(value: int) -> String

### play_sound(sound_path: String)

### generate_fade_display(start_fade_time, end_fade_time, display_time, element)
