extends Node2D

# ------------------------------------------------------------------------------
# SYSTEME DE CALCUL DE STATISTIQUES (TOUR PAR TOUR) - VERSION GLOBALE
# ------------------------------------------------------------------------------

const TEMP_CONFORT_EXT = 0.0   # Idéal extérieur
const TEMP_CONFORT_INT = 18.0  # Idéal intérieur (dans les bâtiments)
const COEFF_TEMP_EXT = 0.3     # Impact du climat polaire
const COEFF_TEMP_INT = 0.2     # Impact du chauffage des bâtiments
const COEFF_BATIMENTS = 0.1

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
	
	# Notification pour l'interface
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

	# --- 1. MALUS TEMPÉRATURE EXTÉRIEURE (Le climat) ---
	var temp_ext = GlobalScript.get_temperature()
	var exces_ext = abs(temp_ext - TEMP_CONFORT_EXT)
	var delta_sante = -(exces_ext * COEFF_TEMP_EXT)

	# --- 2. MALUS TEMPÉRATURE INTÉRIEURE (Le chauffage) ---
	var somme_temp_int = 0.0
	var malus_froid_interne = 0.0
	
	if nb_batiments > 0:
		for id in batiments_sur_carte:
			# On récupère la "temp" stockée dans chaque bâtiment du Global
			somme_temp_int += batiments_sur_carte[id]["temp"]
		
		var moyenne_temp_int = somme_temp_int / nb_batiments
		
		# Si la moyenne est sous 18°C, les colons tombent malades
		if moyenne_temp_int < TEMP_CONFORT_INT:
			var ecart_interne = TEMP_CONFORT_INT - moyenne_temp_int
			malus_froid_interne = -(ecart_interne * COEFF_TEMP_INT)
			print("Malus chauffage (Moyenne: %.1f°C) : %.1f" % [moyenne_temp_int, malus_froid_interne])
	
	delta_sante += malus_froid_interne

	# --- 3. IMPACT DES BÂTIMENTS (Bonheur) ---
	var delta_bonheur = 0.0
	for id in batiments_sur_carte:
		if temp_ext < -50:
			batiments_sur_carte[id]["temp"] -= 1.0 
		var type_nom = batiments_sur_carte[id]["type"]
		var bonus_bat = GlobalScript.get_batiment_bonheur(type_nom)
		delta_bonheur += (bonus_bat * 0.01) * COEFF_BATIMENTS * 10.0

	# --- 4. APPLICATION ---
	current_sante += delta_sante
	
	# Corrélation santé/bonheur
	if current_sante < 40: delta_bonheur -= 10.0
	elif current_sante > 85: delta_bonheur += 5.0
	
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
