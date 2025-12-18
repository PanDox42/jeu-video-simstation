extends Node

# DESCRIPTION :
# FLEMME AUSSI

# [ Santé, Bonheur, Efficacité, Probabilité (%), Nom, Description ]
var catastrophes_disponibles = {
	# Un petit coup de froid, plus fréquent mais moins violent
	"blizzard": [-3, -2, -2, 8, "Blizzard", "Un blizzard léger souffle sur la station. Les sorties sont limitées."],

	# Impact principalement sur l'efficacité, peu sur la santé
	"panne_electrique": [-2, -3, -8, 5, "Panne électrique", "Un court-circuit ralentit les machines. Le moral baisse légèrement."],

	# Réduit de -20 à -7 pour laisser le temps à l'hôpital de soigner
	"grippe_hivernale": [-7, -4, -2, 4, "Grippe hivernale", "Quelques colons toussent. L'infirmerie est sollicitée."],

	# Impact sur le moral uniquement
	"depression_saisonniere": [-2, -10, -5, 3, "Dépression saisonnière", "Le manque de soleil pèse sur le moral de l'équipe."],

	# L'événement rare, réduit de -20 à -12 partout
	"avalanche": [-12, -12, -12, 1, "Avalanche", "Une avalanche a secoué la base. Des réparations sont nécessaires !"]
}

# Var pour determiner quelle catastrophe est active
var catastrophe_active = null

# Fonction qui teste si une catastrophe s'active ce tour ou pas
func verifier_catastrophe() -> Dictionary:
	catastrophe_active = null
	
	# Mélanger les clés pour ne pas que le Blizzard bloque toujours les autres
	var cles = catastrophes_disponibles.keys()
	cles.shuffle()

	for id_catastrophe in cles:
		var info = catastrophes_disponibles[id_catastrophe]
		var chance = randi() % 100
		
		if chance < info[3]: # Probabilité
			catastrophe_active = {
				"id": id_catastrophe,
				"info": info
			}
			print("ÉVÉNEMENT ACTIF : ", id_catastrophe)
			return catastrophe_active
	return {}

func get_catastrophe_active():
	return catastrophe_active
