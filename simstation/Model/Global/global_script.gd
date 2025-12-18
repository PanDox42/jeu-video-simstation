extends Node

# DESCRIPTION :
# FLEMME

signal argent_changed(new_value)
signal batiment_changed(batiment_name, new_value)
signal stats_updated() 
signal demande_ouverture_info(nom_batiment)
signal demande_fermeture_info() 
signal tour_change() 
signal debloque_bat()

# GET
func get_sante() -> int: return Global.stats["sante"]
func get_efficacite() -> int: return Global.stats["efficacite"]
func get_bonheur() -> int: return Global.stats["bonheur"]
func get_argent() -> int: return Global.argent
func get_inventaire() -> Dictionary: return Global.inventaire
func get_camera() -> bool: return Global.camera_enable

# Gestion du temps / Tour
func get_tour() -> int: return Global.tour
func get_temperature() -> int: return Global.environnement["temperature"]

# Gestion Batiments
func get_batiment_prix(nom) -> int: return Global.info_batiments[nom][4]
func get_batiment_info(id): 
	var id_int = int(id) 
	if Global.batiments_place.has(id_int):
		return Global.batiments_place[id_int]
	return null
func get_batiments_counts() -> int: return Global.batiments_place.size()
func get_batiments_place() -> Dictionary: return Global.batiments_place
func get_batiments_data() -> Dictionary: return Global.info_batiments
func get_batiments_debloque(nom_batiment) -> bool: return Global.info_batiments[nom_batiment][3]
func get_batiment_bonheur(nom_batiment) : return Global.info_batiments[nom_batiment][0]
func get_batiment_description(nom_batiment) : return Global.info_batiments[nom_batiment][1]
func get_population() -> Array: return Global.population
func get_batiment_inventaire(nameBat) -> int: return Global.inventaire[nameBat]
func get_recherche_en_cours() -> Dictionary: return Global.recherche_en_cours
func get_recherche_debloque() -> Array: return Global.recherche_debloque

func get_environnement(envi): return Global.environnement[envi]
func get_night_mode() : return Global.environnement["night"]
func get_currently_placing(): return Global.currently_placing
func get_batiment_real_name(batName): return Global.info_batiments[batName][2]
func get_batiment_false_name_by_id(batId): return Global.batiments_place[batId][0]

func get_batiment_taille(batName): return Global.info_batiments[batName][5]

# SET

func set_sante(val): Global.stats["sante"] = val
func set_efficacite(val): Global.stats["efficacite"] = val
func set_bonheur(val): Global.stats["bonheur"] = val
func set_argent(val): Global.argent = val
func set_camera(val): Global.camera_enable = val

func set_night_mode(active : bool) : Global.environnement["night"] = active

func set_tour(val: int):
	Global.tour = val
	
func set_temperature(val: int):
	Global.environnement["temperature"] = val
	
func set_recherche_en_cours(nomRecherche, tourfin):
	Global.recherche_en_cours[nomRecherche] = tourfin
	
func set_batiment_debloque(nom: String):
	Global.info_batiments[nom][3] = true;
	
func set_saison(saison : String) :
	Global.environnement["saison"] = saison
	
func set_currently_placing(placing: bool):
	Global.currently_placing = placing
	
# ADD

func add_recherche_debloque(recherche_nom):
	Global.recherche_debloque.append(recherche_nom) 
	
func add_recherche_en_cours(recherche_nom):
	Global.recherche_en_cours.append(recherche_nom) 

func add_batiment(id_node: int, type_batiment: String):
	var id_int = int(id_node)
	Global.batiments_place[id_int] = {
		"type": type_batiment, 
		"temp": 18, 
		"sante": 100
	}
	
# ERASE

func erase_recherche_en_cours(recherche_nom):
	Global.recherche_en_cours.erase(recherche_nom) 

# AUTRE

func has_recherche(nom: String) -> bool:
	return Global.recherche_debloque.has(nom)
	
func modifier_argent(delta: int) -> void:
	set_argent(get_argent() + delta)
	emit_signal("argent_changed", get_argent())

func modifier_batiment(nom: String, delta: int) -> void:
	var inventaire = get_inventaire()
	if inventaire.has(nom):
		inventaire[nom] += delta
		emit_signal("batiment_changed", nom, inventaire[nom])

func update_population_stats(sante: float, bonheur: float, efficacite: float) -> void:
	for habitant in Global.population:
		habitant["sante"] = lerp(float(habitant["sante"]), sante, 0.8) 
		habitant["bonheur"] = lerp(float(habitant["bonheur"]), bonheur, 0.8)
		habitant["efficacite"] = efficacite
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
