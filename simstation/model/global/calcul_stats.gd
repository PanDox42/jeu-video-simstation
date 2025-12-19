## CalculStats - Système de calcul des statistiques de la station
##
## Gère tous les calculs de statistiques tour par tour pour SimStation.
## Calcule l'impact de la température, des bâtiments, des catastrophes
## sur la santé, le bonheur et l'efficacité de la population.
##
## Ce système utilise des constantes d'équilibrage pour créer une difficulté progressive
## et garantir que le joueur doit construire des infrastructures pour survivre.
extends Node2D

# === CONSTANTES DE TEMPÉRATURE ===

## Température extérieure confortable (-10°C = limite supportable)
const TEMP_COMFORT_EXT = -10.0

## Température intérieure de confort (18°C = température idéale)
const TEMP_COMFORT_INT = 18.0

## Coefficient d'impact de la température extérieure sur la santé par round
const COEFF_TIME_EXT = 0.15

## Coefficient d'impact de la température intérieure sur la santé par round
const COEFF_TIME_INT = 0.1

## Coefficient multiplicateur du bonus de bonheur des bâtiments
const COEFF_BUILDINGS = 0.1

# === CONSTANTES DE SOINS ===

## Bonus de santé apporté par chaque hôpital par round
const BONUS_HEALTH_HOSPITAL = 5.0

## Plafond maximum de santé récupérable via les hôpitaux par round
const CAP_HEALTH_MAX = 15.0

# === CONSTANTES THERMIQUES ===

## Puissance de chauffage apportée par chaque chaufferie
const HEATING_POWER_PER_BUILDING = 9

## Vitesse de refroidissement des bâtiments sans chauffage par round
const COOLING_SPEED = 1.5

## Initialisation des statistiques au démarrage
func _ready() -> void:
	# Initialisation via les getters du GlobalScript
	if GlobalScript.get_health() <= 0:
		GlobalScript.set_health(100)
		GlobalScript.set_hapiness(100)
		GlobalScript.set_efficiency(100)
	
	update_derived_stats()

## Fonction principale appelée à chaque nouveau round
## Enchaîne les calculs dans l'ordre : saisons, catastrophes, stats, signaux
func next_round() -> void:
	_calculate_season_and_weather()
	_gerer_catastrophes()
	_apply_changes_turn()
	update_derived_stats()
	GlobalScript.emit_signal("round_changed")

## Applique un boost immédiat de bonheur lors de la construction d'un bâtiment
## Appelé par le système de construction
## @param building_type_name: Type du bâtiment construit (ex: "dormitory")
func _add_stats_new_building(building_type_name):
	# On récupère le bonus de hapiness statique du bâtiment
	var fixe_bonus = GlobalScript.get_building_hapiness(building_type_name)
	
	if fixe_bonus is int or fixe_bonus is float:
		# Gain immédiat de 10% de la valeur du bâtiment
		var gain = fixe_bonus * 0.1
		GlobalScript.set_hapiness(GlobalScript.get_hapiness() + gain)
		update_derived_stats()

## Recalcule les statistiques dérivées à partir de santé et bonheur
## Formule : Efficacité = (Santé * 0.6) + (Bonheur * 0.4)
## Met à jour le Global et la population avec lerp
func update_derived_stats() -> void:
	var health = float(GlobalScript.get_health())
	var hapiness = float(GlobalScript.get_hapiness())
	
	# Clamp des valeurs entre 0 et 100
	health = clamp(health, 0.0, 100.0)
	hapiness = clamp(hapiness, 0.0, 100.0)
	
	# Calcul de l'Efficacité selon la formule :
	# $$Efficacité = (Santé \times 0.6) + (Bonheur \times 0.4)$$
	var efficiency = (health * 0.6) + (hapiness * 0.4)
	efficiency = clamp(efficiency, 0.0, 100.0)
	
	# Mise à jour du Global
	GlobalScript.set_health(int(health))
	GlobalScript.set_hapiness(int(hapiness))
	GlobalScript.set_efficiency(int(efficiency))
	
	# Mise à jour de la population (lerp interne au GlobalScript)
	GlobalScript.update_population_stats(health, hapiness, efficiency)
	
	print("Stats : Santé %d%% | Bonheur %d%% | Efficacité %d%%" % [health, hapiness, efficiency])

## Calcule et applique la saison suivante avec sa température
## Cycle de 4 saisons : Été (0) -> Automne (1) -> Hiver (2) -> Printemps (3)
## - Été: -25°C à -40°C
## - Automne: -40°C à -55°C  
## - Hiver: -60°C à -80°C (le plus dangereux)
## - Printemps: -45°C à -60°C
func _calculate_season_and_weather() -> void:
	var current_round = GlobalScript.get_round() + 1
	GlobalScript.set_round(current_round)
	
	var season_index = current_round % 4
	var new_temp = 0
	var season_name = ""
	
	match season_index:
		0: 
			new_temp = -25 - (randi() % 15)
			season_name = "Été austral"
		1: 
			new_temp = -40 - (randi() % 15)
			season_name = "Automne austral"
		2: 
			new_temp = -60 - (randi() % 20)
			season_name = "Hiver austral"
		3: 
			new_temp = -45 - (randi() % 15)
			season_name = "Printemps austral"
	
	GlobalScript.set_temperature(new_temp)
	GlobalScript.set_season(season_name)

## Applique tous les changements statistiques du round
## Séquence de calcul :
## 1. Comptage des bâtiments spéciaux (chaufferies, hôpitaux)
## 2. Simulation thermique (chauffage/refroidissement des bâtiments)
## 3. Calcul impact température sur santé
## 4. Calcul impact bâtiments sur bonheur
## 5. Application finale des deltas
func _apply_changes_turn() -> void:
	var current_health = float(GlobalScript.get_health())
	var current_hapiness = float(GlobalScript.get_hapiness())
	var buildings_on_map = GlobalScript.get_buildings_place()
	var nb_buildings = buildings_on_map.size()

	# --- 1. COMPTAGE ---
	var nb_boiler_rooms = 0
	var nb_hospitals = 0
	for id in buildings_on_map:
		var type = buildings_on_map[id]["type"]
		if type == "boiler_room": nb_boiler_rooms += 1
		elif type == "hospital": nb_hospitals += 1
	
	# --- 2. LOGIQUE THERMIQUE ---
	var total_heating_speed = nb_boiler_rooms * HEATING_POWER_PER_BUILDING
	var sum_temp_int = 0.0
	
	for id in buildings_on_map:
		var t_interne = buildings_on_map[id]["temp"]
		if nb_boiler_rooms > 0:
			t_interne = min(TEMP_COMFORT_INT, t_interne + total_heating_speed)
		else:
			t_interne = max(-20.0, t_interne - COOLING_SPEED)
		buildings_on_map[id]["temp"] = t_interne
		sum_temp_int += t_interne

	# --- 3. CALCUL DU DELTA SANTÉ (L'ÉQUILIBRAGE) ---
	var temp_ext = GlobalScript.get_temperature()
	var exces_ext = abs(temp_ext - TEMP_COMFORT_EXT)
	
	# --- MODIFICATION ICI : RÈGLE DES 2 CHAUFFERIES ---
	var efficiency_insulation = 1.0
	if nb_boiler_rooms >= 2:
		# Si on a 2 chaufferies ou plus, on réduit l'impact du froid extérieur de 70%
		efficiency_insulation = 0.3 
		print("PROTECTION THERMIQUE : 2+ Chaufferies réduisent le froid extérieur.")
	elif nb_boiler_rooms == 1:
		# Une seule chaufferie réduit le froid de 20%
		efficiency_insulation = 0.8

	# Calcul du malus extérieur avec l'isolation des chaufferies
	var delta_health = -(exces_ext * (COEFF_TIME_EXT * efficiency_insulation))

	# Malus thermique interne (si les bâtiments sont froids)
	var average_temp_int = 18.0
	if nb_buildings > 0:
		average_temp_int = sum_temp_int / nb_buildings
		if average_temp_int < TEMP_COMFORT_INT:
			delta_health -= (TEMP_COMFORT_INT - average_temp_int) * COEFF_TIME_INT

	# Bonus de récupération si la base est PARFAITEMENT chauffée (18°C)
	if average_temp_int >= 18.0 and nb_boiler_rooms >= 2:
		delta_health += 2.0 # Bonus "Confort au chaud"
		print("BONUS : Base bien chauffée, la santé remonte doucement.")

	# --- 4. SOINS ET BONHEUR ---
	if nb_hospitals > 0:
		delta_health += min(nb_hospitals * BONUS_HEALTH_HOSPITAL, CAP_HEALTH_MAX)

	var delta_hapiness = 0.0
	for id in buildings_on_map:
		var name_type = buildings_on_map[id]["type"]
		delta_hapiness += (GlobalScript.get_building_hapiness(name_type) * 0.01) * COEFF_BUILDINGS * 10.0

	# --- 5. APPLICATION ---
	current_health += delta_health
	
	if current_health < 25: delta_hapiness -= 10.0
	elif current_health > 75: delta_hapiness += 5.0
	current_hapiness += delta_hapiness
	
	GlobalScript.set_health(int(current_health))
	GlobalScript.set_hapiness(int(current_hapiness))

## Vérifie et applique une éventuelle catastrophe aléatoire
## Utilise le système Catastrophes.verify_disaster()
## Applique directement les malus de santé et bonheur si une catastrophe se déclenche
func _gerer_catastrophes() -> void:
	var disaster = Catastrophes.verify_disaster()
	
	if not disaster.is_empty():
		var info = disaster["info"]
		# info = [Sante, Bonheur, Efficacité, Prob, name, Desc]
		GlobalScript.set_health(GlobalScript.get_health() + int(info[0]))
		GlobalScript.set_hapiness(GlobalScript.get_hapiness() + int(info[1]))
		print("Evénement : %s" % info[4])
