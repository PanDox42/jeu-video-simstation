## GameEndManager - Gestionnaire de fin de partie
##
## Vérifie les conditions de victoire et de défaite à chaque tour.
## Conditions de victoire : 20 rounds + toutes recherches + stats >40%
## Conditions de défaite : Une stat atteint 0 OU échec au round 20
extends Node

## Émis quand le joueur gagne
signal game_won

## Émis quand le joueur perd
## @param reason: Raison de la défaite
signal game_lost(reason: String)

## Round final pour la victoire/défaite
const FINAL_ROUND = 20

## Seuil minimum pour les statistiques (victoire)
const MIN_STATS_THRESHOLD = 40

## Nombre total de recherches dans le jeu
const TOTAL_RESEARCHES = 7

## Vérifie les conditions de fin de partie
## Appelé automatiquement à chaque changement de round
func check_end_conditions():
	var current_round = GlobalScript.get_round()
	var health = GlobalScript.get_health()
	var happiness = GlobalScript.get_hapiness()
	var efficiency = GlobalScript.get_efficiency()
	
	# DÉFAITE IMMÉDIATE : Une stat atteint 0
	if health <= 0:
		emit_signal("game_lost", "Votre équipe n'a pas survécu au froid extrême...")
		return
	
	if happiness <= 0:
		emit_signal("game_lost", "Le moral de l'équipe s'est complètement effondré...")
		return
	
	if efficiency <= 0:
		emit_signal("game_lost", "L'équipe est devenue totalement inefficace...")
		return
	
	# ROUND 20 : Vérifier victoire ou défaite
	if current_round >= FINAL_ROUND:
		if _check_victory_conditions():
			emit_signal("game_won")
		else:
			emit_signal("game_lost", "Mission échouée après " + str(FINAL_ROUND) + " rounds...")

## Vérifie si toutes les conditions de victoire sont remplies
## @return: true si victoire, false sinon
func _check_victory_conditions() -> bool:
	var health = GlobalScript.get_health()
	var happiness = GlobalScript.get_hapiness()
	var efficiency = GlobalScript.get_efficiency()
	
	# Condition 1 : Toutes les stats > 40
	if health <= MIN_STATS_THRESHOLD:
		return false
	if happiness <= MIN_STATS_THRESHOLD:
		return false
	if efficiency <= MIN_STATS_THRESHOLD:
		return false
	
	# Condition 2 : Toutes les recherches terminées
	var completed_researches = GlobalScript.get_search_unblocked().size()
	if completed_researches < TOTAL_RESEARCHES:
		return false
	
	return true
