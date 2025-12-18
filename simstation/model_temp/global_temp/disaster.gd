extends Node

# DESCRIPTION :
# FLEMME AUSSI

# [ Santé, Bonheur, Efficacité, Probabilité (%), name, Description ]
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

# Var pour determiner quelle disaster est active
var disaster_activated = null

# Fonction qui teste si une disaster s'active ce round ou pas
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

func get_active_disaster():
	return disaster_activated
