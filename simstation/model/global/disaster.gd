## Catastrophes - Système d'événements aléatoires pour SimStation
##
## Gère les catastrophes et événements aléatoires qui peuvent affecter la station.
## Chaque round, le système vérifie si une catastrophe se déclenche selon
## des probabilités définies. Une seule catastrophe peut se produire par round.
##
## Les catastrophes affectent Santé, Bonheur et Efficacité avec des intensités variées.
extends Node

## Catalogue de toutes les catastrophes disponibles
## Format par catastrophe: [Santé_Delta, Bonheur_Delta, Efficacité_Delta, Probabilité_%, Nom, Description]
## 
## **Types de catastrophes:**
## - blizzard: Tempête fréquente (8% de chance), impact léger (-3/-2/-2)
## - electrical_breakdown: Panne électrique (5%), impact moyen sur efficacité (-2/-3/-8)
## - winter_flu: Grippe hivernale (4%), impact santé modéré (-7/-4/-2)
## - seasonal_depression: Dépression saisonnière (3%), impact moral fort (-2/-10/-5)
## - avalanche: Événement rare (1%), impact critique partout (-12/-12/-12)
var disasters_available = {
	# Un petit coup de froid, plus fréquent mais moins violent
	"blizzard": [-3, -2, -2, 8, "Tempête de neige", "Un blizzard léger souffle sur la station. Les sorties sont limitées."],

	# Impact principalement sur l'efficacité, peu sur la santé
	"electrical_breakdown": [-2, -3, -8, 5, "Panne électrique", "Un court-circuit ralentit les machines. Le moral baisse légèrement."],

	# Réduit de -20 à -7 pour laisser le temps à l'hôpital de soigner
	"winter_flu": [-7, -4, -2, 4, "Grippe hivernale", "Quelques colons toussent. L'infirmerie est sollicitée."],

	# Impact sur le moral uniquement
	"seasonal_depression": [-2, -10, -5, 3, "Dépression saisonnière", "Le manque de soleil pèse sur le moral de l'équipe."],

	# L'événement rare, réduit de -20 à -12 partout
	"avalanche": [-12, -12, -12, 1, "Avalanche", "Une avalanche a secoué la base. Des réparations sont nécessaires !"]
}

## Stocke la catastrophe actuellement active (null si aucune)
var disaster_activated = null

## Vérifie aléatoirement si une catastrophe se déclenche ce round
## Utilise un système de mélange pour éviter que le blizzard bloque toujours les autres
## @return: Dictionnaire {"id": nom_catastrophe, "info": [données]} ou {} si aucune
func verify_disaster() -> Dictionary:
	disaster_activated = null
	
	# Mélanger les clés pour ne pas que le Blizzard bloque toujours les autres
	var keys = disasters_available.keys()
	keys.shuffle()

	for id_disaster in keys:
		var info = disasters_available[id_disaster]
		var chance = randi() % 100
		
		if chance < info[3]: # Probabilité
			disaster_activated = {
				"id": id_disaster,
				"info": info
			}
			print("ÉVÉNEMENT ACTIF : ", id_disaster)
			return disaster_activated
	return {}

## Récupère la catastrophe actuellement active
## @return: Dictionnaire de la catastrophe ou null
func get_active_disaster():
	return disaster_activated
