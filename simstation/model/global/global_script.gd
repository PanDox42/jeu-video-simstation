## GlobalScript - Singleton utilitaire pour SimStation
##
## Autoload qui fournit une interface complète pour accéder et modifier les données
## du singleton Global. Contient tous les getters, setters et fonctions utilitaires
## pour gérer l'économie, les bâtiments, les statistiques et l'environnement.
##
## Ce script agit comme une couche d'abstraction entre le code du jeu et le Global,
## et émet des signaux pour notifier les changements d'état.
extends Node

# === SIGNAUX ===

## Émis quand l'argent du joueur change
## @param new_value: Nouvelle valeur de l'argent
signal money_changed(new_value)

## Émis quand la quantité d'un bâtiment dans l'inventaire change
## @param batiment_name: Nom du type de bâtiment
## @param new_value: Nouvelle quantité
signal building_changed(batiment_name, new_value)

## Émis quand les statistiques de la population sont mises à jour
signal stats_updated()

## Émis pour demander l'ouverture du panneau d'info d'un bâtiment
## @param building_name: Nom du bâtiment à afficher
signal request_opening_info(building_name)

## Émis pour demander la fermeture du panneau d'info
signal closure_request_info()

## Émis quand le numéro du round change (nouveau tour)
signal round_changed()

## Émis quand un nouveau bâtiment est débloqué
signal unblocked_building()

# === GETTERS - STATISTIQUES ===

## Récupère la santé moyenne de la station
## @return: Valeur de santé (0-100)
func get_health() -> int: return Global.stats["health"]

## Récupère l'efficacité moyenne de la station
## @return: Valeur d'efficacité (0-100)
func get_efficiency() -> int: return Global.stats["efficiency"]

## Récupère le bonheur moyen de la station
## @return: Valeur de bonheur (0-100)
func get_hapiness() -> int: return Global.stats["happiness"]

## Récupère l'argent disponible
## @return: Crédits disponibles
func get_money() -> int: return Global.money

## Récupère tout l'inventaire des bâtiments
## @return: Dictionnaire {nom_batiment: quantité}
func get_inventory() -> Dictionary: return Global.inventory

## Récupère l'état d'activation de la caméra
## @return: true si la caméra est activée
func get_camera() -> bool: return Global.camera_enable

# === GETTERS - TEMPS / ENVIRONNEMENT ===

## Récupère le numéro du round actuel
## @return: Numéro du round (chaque round = 3 mois)
func get_round() -> int: return Global.round

## Récupère la température extérieure actuelle
## @return: Température en °C (négatif)
func get_temperature() -> int: return Global.environnement["temperature"]

## Récupère une donnée d'environnement spécifique
## @param environnement: Clé de la donnée ("temperature", "season", "night")
## @return: Valeur de la donnée demandée
func get_environnement(environnement): return Global.environnement[environnement]

## Récupère l'état du mode nuit
## @return: true si le mode nuit est actif
func get_night_mode() : return Global.environnement["night"]

# === GETTERS - BÂTIMENTS ===

## Récupère le prix d'achat d'un type de bâtiment
## @param name: Nom du type de bâtiment (ex: "dormitory")
## @return: Prix en crédits
func get_building_price(name) -> int: return Global.buildings_info[name][4]

## Récupère les informations d'un bâtiment placé sur la carte
## @param id: ID du nœud du bâtiment sur la carte
## @return: Dictionnaire {type, temp, health} ou null si introuvable
func get_info_building(id):
	if Global.buildings_place.has(id):
		return Global.buildings_place[id]

	var id_str = str(id)
	if Global.buildings_place.has(id_str):
		return Global.buildings_place[id_str]

	var id_int = int(id)
	if Global.buildings_place.has(id_int):
		return Global.buildings_place[id_int]

	print("ERREUR critique : Impossible de trouver l'ID ", id, " dans buildings_place")
	return null

## Récupère le nombre total de bâtiments placés sur la carte
## @return: Nombre de bâtiments
func get_buildings_counts() -> int: return Global.buildings_place.size()

## Récupère tous les bâtiments placés sur la carte
## @return: Dictionnaire {id: {type, temp, health}}
func get_buildings_place() -> Dictionary: return Global.buildings_place

## Récupère toutes les données statiques des types de bâtiments
## @return: Dictionnaire complet de buildings_info
func get_buildings_data() -> Dictionary: return Global.buildings_info

## Vérifie si un type de bâtiment est débloqué
## @param building_name: Nom du type de bâtiment
## @return: true si débloqué
func get_buildings_unblocked(building_name) -> bool: return Global.buildings_info[building_name][3]

## Récupère le bonus de bonheur d'un type de bâtiment
## @param building_name: Nom du type de bâtiment
## @return: Valeur du bonus de bonheur
func get_building_hapiness(building_name) : return Global.buildings_info[building_name][0]

## Récupère la description d'un type de bâtiment
## @param building_name: Nom du type de bâtiment
## @return: Texte de description
func get_building_description(building_name) : return Global.buildings_info[building_name][1]

## Récupère le nom d'affichage d'un type de bâtiment
## @param building_name: Nom du type de bâtiment (clé interne)
## @return: Nom lisible pour l'interface (ex: "Dortoir")
func get_building_display_name(building_name): return Global.buildings_info[building_name][2]

## Récupère le type d'un bâtiment placé via son ID
## @param building_id: ID du bâtiment sur la carte
## @return: Type du bâtiment (ex: "dormitory")
func get_building_false_name_by_id(building_id): return Global.buildings_place[building_id][0]

## Récupère la consommation énergétique d'un type de bâtiment
## @param building_name: Nom du type de bâtiment
## @return: Consommation en watts
func get_size_building(building_name): return Global.buildings_info[building_name][5]

## Récupère la quantité d'un type de bâtiment dans l'inventaire
## @param nameBat: Nom du type de bâtiment
## @return: Quantité disponible
func get_building_inventory(nameBat) -> int: return Global.inventory[nameBat]

# === GETTERS - POPULATION & RECHERCHE ===

## Récupère la liste complète de la population
## @return: Tableau d'habitants avec leurs stats
func get_population() -> Array: return Global.population

## Récupère les recherches actuellement en cours
## @return: Dictionnaire {nom_recherche: round_de_fin}
func get_research_in_progress() -> Dictionary: return Global.research_in_progress

## Récupère la liste des recherches déjà débloquées
## @return: Tableau de noms de recherches
func get_search_unblocked() -> Array: return Global.search_unblocked

## Récupère l'état de placement de bâtiment
## @return: true si un bâtiment est en cours de placement
func get_currently_placing(): return Global.currently_placing


func get_save_data():
	# 1. On prépare la structure de base
	var save_dict = {
		"station_name": Global.name_station,
		"money": Global.money,
		"inventory": Global.inventory,
		"stats": Global.stats,
		"environment": Global.environnement,
		"round": Global.round,
		"unblocked": Global.search_unblocked,
		"bat_info": Global.buildings_info,
		"bat_place": {} # On le laisse vide pour le remplir proprement après
	}

	# 2. Conversion CRUCIALE des Vector2 en dictionnaires (x, y) pour le JSON
	for id in Global.buildings_place:
		var b_data = Global.buildings_place[id].duplicate()
		var pos = b_data["position"]

		# On transforme le Vector2 en quelque chose que le JSON comprend
		b_data["position"] = {"x": pos.x, "y": pos.y}

		# On ajoute cette copie propre au dictionnaire de sauvegarde
		save_dict["bat_place"][id] = b_data

	# 3. On ne renvoie le dictionnaire qu'UNE SEULE FOIS, à la toute fin
	return save_dict

func get_name_station(): return Global.name_station



# === SETTERS - STATISTIQUES ===

## Définit la santé moyenne de la station
## @param val: Nouvelle valeur (0-100)
func set_health(val): Global.stats["health"] = val

## Définit l'efficacité moyenne de la station
## @param val: Nouvelle valeur (0-100)
func set_efficiency(val): Global.stats["efficiency"] = val

## Définit le bonheur moyen de la station
## @param val: Nouvelle valeur (0-100)
func set_hapiness(val): Global.stats["happiness"] = val

## Définit l'argent disponible
## @param val: Nouvelle quantité de crédits
func set_money(val): Global.money = val

## Définit l'état d'activation de la caméra
## @param val: true pour activer la caméra
func set_camera(val): Global.camera_enable = val

# === SETTERS - ENVIRONNEMENT ===

## Définit l'activation du mode nuit
## @param active: true pour activer le mode nuit
func set_night_mode(active : bool) : Global.environnement["night"] = active
	
## Définit la température extérieure
## @param val: Nouvelle température en °C
func set_temperature(val: int):
	Global.environnement["temperature"] = val
	
## Définit la saison actuelle
## @param saison: Nom de la saison ("Été austral", etc.)
func set_season(saison : String) :
	Global.environnement["season"] = saison
	
## Définit l'état de placement de bâtiment
## @param placing: true si un bâtiment est en cours de placement
func set_currently_placing(placing: bool):
	Global.currently_placing = placing

# === SETTERS - RECHERCHE & BÂTIMENTS ===

## Enregistre une recherche en cours avec son round de fin
## @param search_name: Nom de la recherche
## @param end_round: Numéro du round où elle sera terminée
func set_research_in_progress(search_name, end_round):
	Global.research_in_progress[search_name] = end_round

func set_inventory(inventory):
	Global.inventory = inventory

func set_stats(stats):
	Global.stats = stats

func set_environement(environment):
	Global.environnement = environment

func set_round(round):
	Global.round = round

func set_search_unblocked(unblocked):
	Global.search_unblocked = unblocked

func set_name_station(newNameStation):
	Global.name_station = newNameStation

func set_batiment_place(newBatPlace):
	Global.buildings_place = newBatPlace

func set_batiment_info(newBatInfo):
	Global.buildings_info = newBatInfo

## Débloque un type de bâtiment
## @param name: Nom du type de bâtiment à débloquer
func set_building_unblocked(name: String):
	Global.buildings_info[name][3] = true


# === FONCTIONS D'AJOUT ===

## Ajoute une recherche à la liste des recherches débloquées
## @param search_name: Nom de la recherche à ajouter
func add_search_unblocked(search_name):
	Global.search_unblocked.append(search_name) 
	
## Ajoute une recherche en cours (DEPRECATED - typo dans le nom)
## @param search_name: Nom de la recherche
func ass_research_in_progress(search_name):
	Global.research_in_progress.append(search_name) 


## Place un nouveau bâtiment sur la carte
## @param id_node: ID du nœud sur la carte
## @param type: Type du bâtiment (ex: "dormitory")
func add_building(id_node: int, type: String, position:Vector2):
	var id_int = int(id_node)
	Global.buildings_place[id_int] = {
		"type": type, 
		"position": position,
		"temp": 18,
		"health": 100
	}
	
# === FONCTIONS DE SUPPRESSION ===

## Retire une recherche de la liste des recherches en cours
## @param search_name: Nom de la recherche à retirer
func erase_research_in_progress(search_name):
	Global.research_in_progress.erase(search_name) 

# === FONCTIONS UTILITAIRES ===

## Vérifie si une recherche est déjà débloquée
## @param name: Nom de la recherche
## @return: true si la recherche est débloquée
func has_search(name: String) -> bool:
	return Global.search_unblocked.has(name)
	
## Modifie l'argent du joueur (ajoute ou retire)
## Émet le signal money_changed
## @param delta: Montant à ajouter (positif) ou retirer (négatif)
func edit_money(delta: int) -> void:
	set_money(get_money() + delta)
	emit_signal("money_changed", get_money())

## Modifie la quantité d'un bâtiment dans l'inventaire
## Émet le signal building_changed
## @param name: Type de bâtiment
## @param delta: Quantité à ajouter (positif) ou retirer (négatif)
func edit_building(name: String, delta: int) -> void:
	var inventory = get_inventory()
	if inventory.has(name):
		inventory[name] += delta
		emit_signal("building_changed", name, inventory[name])

## Met à jour les statistiques de toute la population avec un lerp
## Émet le signal stats_updated
## @param health: Valeur cible de santé
## @param hapiness: Valeur cible de bonheur
## @param efficiency: Valeur d'efficacité (appliquée directement)
func update_population_stats(health: float, hapiness: float, efficiency: float) -> void:
	for habitant in Global.population:
		habitant["health"] = lerp(float(habitant["health"]), health, 0.8) 
		habitant["happiness"] = lerp(float(habitant["happiness"]), hapiness, 0.8)
		habitant["efficiency"] = efficiency
	emit_signal("stats_updated")

## Formate un nombre en ajoutant des espaces tous les 3 chiffres
## @param value: Nombre à formater
## @return: String formaté (ex: "1 234 567")
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
	
## Joue un son en créant un AudioStreamPlayer temporaire
## Le player se supprime automatiquement à la fin du son
## @param sound_path: Chemin vers le fichier audio (ex: "res://sounds/click.ogg")
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

## Crée une animation de fade-in/fade-out pour un élément UI
## Utile pour afficher temporairement des notifications
## @param start_fade_time: Durée de l'apparition en secondes
## @param end_fade_time: Durée de la disparition en secondes
## @param display_time: Durée d'affichage en secondes
## @param element: Nœud UI à animer (doit avoir modulate.a)
func generate_fade_display(start_fade_time, end_fade_time, display_time, element):
	# Sécurité immédiate : si l'élément est null, on ne fait rien
	if not is_instance_valid(element):
		return

	element.modulate.a = 0
	element.visible = true
	
	# Création du Tween
	var tween = create_tween().bind_node(element)

	# 1. Apparition en start_fade_time seconde
	tween.tween_property(element, "modulate:a", 1.0, start_fade_time)
	
	# 2. Attendre display_time secondes
	tween.tween_interval(display_time)
	
	# 3. Disparition en end_fade_time seconde
	tween.tween_property(element, "modulate:a", 0.0, end_fade_time)
	
	# 4. Cacher le nœud à la fin pour la performance
	tween.tween_callback(func(): element.visible = false)
