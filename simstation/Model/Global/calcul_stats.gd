extends Node2D

# ------------------------------------------------------------------------------
# SYSTEME DE CALCUL DE STATISTIQUES (TOUR PAR TOUR)
# ------------------------------------------------------------------------------

const TEMP_CONFORT_EXT = -10.0
const TEMP_CONFORT_INT = 18.0
const COEFF_TEMP_EXT = 0.15
const COEFF_TEMP_INT = 0.1
const COEFF_BATIMENTS = 0.1
const BONUS_SANTE_HOPITAL = 5.0
const CAP_SOINS_MAX = 15.0

const PUISSANCE_CHAUFFAGE_PAR_BATIMENT = 9
const VITESSE_REFROIDISSEMENT = 1.5

func _ready() -> void:
	# Initialisation via les getters du GlobalScript
	if GlobalScript.get_sante() <= 0:
		GlobalScript.set_sante(100)
		GlobalScript.set_bonheur(100)
		GlobalScript.set_efficacite(100)
	
	actualiser_stats_derivees()

func passer_tour() -> void:
	_calculer_saison_et_meteo()
	_gerer_catastrophes()
	_appliquer_changements_tour()
	actualiser_stats_derivees()
	GlobalScript.emit_signal("tour_change")

# Appelé lors de la construction pour un boost immédiat
func _ajouter_stats_nouveau_batiment(nom_type_batiment):
	# On récupère le bonus de bonheur statique du bâtiment
	var bonus_fixe = GlobalScript.get_batiment_bonheur(nom_type_batiment)
	
	if bonus_fixe is int or bonus_fixe is float:
		# Gain immédiat de 10% de la valeur du bâtiment
		var gain = bonus_fixe * 0.1
		GlobalScript.set_bonheur(GlobalScript.get_bonheur() + gain)
		actualiser_stats_derivees()

func actualiser_stats_derivees() -> void:
	var sante = float(GlobalScript.get_sante())
	var bonheur = float(GlobalScript.get_bonheur())
	
	# Clamp des valeurs entre 0 et 100
	sante = clamp(sante, 0.0, 100.0)
	bonheur = clamp(bonheur, 0.0, 100.0)
	
	# Calcul de l'Efficacité selon la formule :
	# $$Efficacité = (Santé \times 0.6) + (Bonheur \times 0.4)$$
	var efficacite = (sante * 0.6) + (bonheur * 0.4)
	efficacite = clamp(efficacite, 0.0, 100.0)
	
	# Mise à jour du Global
	GlobalScript.set_sante(int(sante))
	GlobalScript.set_bonheur(int(bonheur))
	GlobalScript.set_efficacite(int(efficacite))
	
	# Mise à jour de la population (lerp interne au GlobalScript)
	GlobalScript.update_population_stats(sante, bonheur, efficacite)
	
	print("Stats : Santé %d%% | Bonheur %d%% | Efficacité %d%%" % [sante, bonheur, efficacite])

func _calculer_saison_et_meteo() -> void:
	var tour_actuel = GlobalScript.get_tour() + 1
	GlobalScript.set_tour(tour_actuel)
	
	var saison_index = tour_actuel % 4
	var new_temp = 0
	var nom_saison = ""
	
	match saison_index:
		0: 
			new_temp = -25 - (randi() % 15)
			nom_saison = "Été austral"
		1: 
			new_temp = -40 - (randi() % 15)
			nom_saison = "Automne austral"
		2: 
			new_temp = -60 - (randi() % 20)
			nom_saison = "Hiver austral"
		3: 
			new_temp = -45 - (randi() % 15)
			nom_saison = "Printemps austral"
	
	GlobalScript.set_temperature(new_temp)
	GlobalScript.set_saison(nom_saison)

func _appliquer_changements_tour() -> void:
	var current_sante = float(GlobalScript.get_sante())
	var current_bonheur = float(GlobalScript.get_bonheur())
	var batiments_sur_carte = GlobalScript.get_batiments_place()
	var nb_batiments = batiments_sur_carte.size()

	# --- 1. COMPTAGE ---
	var nb_chaufferies = 0
	var nb_hopitaux = 0
	for id in batiments_sur_carte:
		var type = batiments_sur_carte[id]["type"]
		if type == "chaufferie": nb_chaufferies += 1
		elif type == "hopital": nb_hopitaux += 1
	
	# --- 2. LOGIQUE THERMIQUE ---
	var vitesse_chauffage_totale = nb_chaufferies * PUISSANCE_CHAUFFAGE_PAR_BATIMENT
	var somme_temp_int = 0.0
	
	for id in batiments_sur_carte:
		var t_interne = batiments_sur_carte[id]["temp"]
		if nb_chaufferies > 0:
			t_interne = min(TEMP_CONFORT_INT, t_interne + vitesse_chauffage_totale)
		else:
			t_interne = max(-20.0, t_interne - VITESSE_REFROIDISSEMENT)
		batiments_sur_carte[id]["temp"] = t_interne
		somme_temp_int += t_interne

	# --- 3. CALCUL DU DELTA SANTÉ (L'ÉQUILIBRAGE) ---
	var temp_ext = GlobalScript.get_temperature()
	var exces_ext = abs(temp_ext - TEMP_CONFORT_EXT)
	
	# --- MODIFICATION ICI : RÈGLE DES 2 CHAUFFERIES ---
	var efficacite_isolation = 1.0
	if nb_chaufferies >= 2:
		# Si on a 2 chaufferies ou plus, on réduit l'impact du froid extérieur de 70%
		efficacite_isolation = 0.3 
		print("PROTECTION THERMIQUE : 2+ Chaufferies réduisent le froid extérieur.")
	elif nb_chaufferies == 1:
		# Une seule chaufferie réduit le froid de 20%
		efficacite_isolation = 0.8

	# Calcul du malus extérieur avec l'isolation des chaufferies
	var delta_sante = -(exces_ext * (COEFF_TEMP_EXT * efficacite_isolation))

	# Malus thermique interne (si les bâtiments sont froids)
	var moyenne_temp_int = 18.0
	if nb_batiments > 0:
		moyenne_temp_int = somme_temp_int / nb_batiments
		if moyenne_temp_int < TEMP_CONFORT_INT:
			delta_sante -= (TEMP_CONFORT_INT - moyenne_temp_int) * COEFF_TEMP_INT

	# Bonus de récupération si la base est PARFAITEMENT chauffée (18°C)
	if moyenne_temp_int >= 18.0 and nb_chaufferies >= 2:
		delta_sante += 2.0 # Bonus "Confort au chaud"
		print("BONUS : Base bien chauffée, la santé remonte doucement.")

	# --- 4. SOINS ET BONHEUR ---
	if nb_hopitaux > 0:
		delta_sante += min(nb_hopitaux * BONUS_SANTE_HOPITAL, CAP_SOINS_MAX)

	var delta_bonheur = 0.0
	for id in batiments_sur_carte:
		var type_nom = batiments_sur_carte[id]["type"]
		delta_bonheur += (GlobalScript.get_batiment_bonheur(type_nom) * 0.01) * COEFF_BATIMENTS * 10.0

	# --- 5. APPLICATION ---
	current_sante += delta_sante
	
	if current_sante < 25: delta_bonheur -= 10.0
	elif current_sante > 75: delta_bonheur += 5.0
	current_bonheur += delta_bonheur
	
	GlobalScript.set_sante(int(current_sante))
	GlobalScript.set_bonheur(int(current_bonheur))

func _gerer_catastrophes() -> void:
	var catastrophe = Catastrophes.verifier_catastrophe()
	
	if not catastrophe.is_empty():
		var info = catastrophe["info"]
		# info = [Sante, Bonheur, Efficacité, Prob, Nom, Desc]
		GlobalScript.set_sante(GlobalScript.get_sante() + int(info[0]))
		GlobalScript.set_bonheur(GlobalScript.get_bonheur() + int(info[1]))
		print("Evénement : %s" % info[4])
