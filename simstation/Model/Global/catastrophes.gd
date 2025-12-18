extends Node

# DESCRIPTION :
# FLEMME AUSSI

# [ Santé, Bonheur, Efficacité, Probabilité (%), Nom, Description ]
var catastrophes_disponibles = {
	"blizzard": [-5, -5, -5, 200, "Blizzard", "Un blizzard violent frappe la station ! \nLes conditions météo extrêmes affectent la santé et le moral."],
	"panne_electrique": [-10, -5, -15, 15, "Panne électrique", "Une panne majeure du système électrique plonge une partie de la station dans le noir."],
	"grippe_hivernale": [-20, -10, -5, 10, "Grippe hivernale", "Une épidémie de grippe se propage dans la base confinée, affectant gravement l'équipe."],
	"depression_saisonniere": [-10, -20, -10, 5, "Dépression saisonnière", "L'isolement et le froid plongent l'équipe dans un profond malaise psychologique."],
	"avalanche": [-20, -20, -20, 1, "Avalanche", "Une avalanche massive s'abat sur la base ! \nDégâts importants et équipe en état de choc."]
}

# Var pour determiner quelle catastrophe est active
var catastrophe_active = null

# Fonction qui teste si une catastrophe s'active ce tour ou pas
func verifier_catastrophe() -> Dictionary:
	catastrophe_active = null
	
	for id_catastrophe in catastrophes_disponibles:
		var info = catastrophes_disponibles[id_catastrophe]
		var chance = randi() % 100
		
		if chance < info[3]:  # Probabilité 
			catastrophe_active = {
				"id": id_catastrophe,
				"info": info
			}
			print(catastrophe_active)
			return catastrophe_active
	return {}

# Retourne la catastophe active
func get_catastrophe_active():
	return catastrophe_active
