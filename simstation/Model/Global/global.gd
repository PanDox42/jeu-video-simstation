extends Node

# DESCRIPTION :
# Global qui sert à stocker les infos du joueur, des stats de la partie, des batiments, 
# de la population, de l'argent et du nombre de tour de la partie.

var camera_enable = true;
var currently_placing = false;
var user = {"nom":"Martin","time":3}

var population = [
	{"sante": 100, "efficacite": 100, "bonheur": 50}
]

var recherche_debloque = []
var recherche_en_cours = {}

var argent = 3000000

# ce que le joueur possède
var inventaire = {
	"labo_recherche": 1, 
	"dortoir": 2, 
	"chaufferie": 1, 
	"cantine": 0, 
	"hopital": 1,
	"observatoire" : 0,
	"salle_sport": 0, 
	"salle_repos": 0, 
}

var batiments_place = {
	# id : {type, temp, sante}
}

var info_batiments = {
	# [ Bonheur, Description, Nom (à afficher), Débloqué ou pas, prix ]
	
	# --- Bâtiments de base (Débloqués par défaut) ---
	"labo_recherche": [0, "Permet de faire des recherches scientifiques", "Laboratoire", true, 646463, 384],
	"dortoir": [60, "Permet de se reposer tranquillement", "Dortoir", true, 54867, 128],
	"chaufferie": [60, "Chauffe tous les batiments de la station", "Chaufferie", true, 54867, 384],
	
	# --- Bâtiments à débloquer via l'Arbre "Infrastructure" ---
	"salle_sport": [70, "Améliore la condition physique des habitants", "Salle de sport", false, 957376, 128],
	"cantine": [70, "Fournit de la nourriture chaude", "Cantine", false, 50000, 256],
	"salle_repos": [60, "Endroit calme pour se détendre", "Salle de repos", false, 75743, 256],
	
	# --- Bâtiments à débloquer via l'Arbre "Science" ---
	"hopital": [60, "Permet de soigner les malades graves", "Hopital", true, 100000, 256],
	"observatoire" : [50, "Permet de découvrir de nouvelles étoiles", "Observatoire", false, 100000, 384],
}

var stats = {
	"sante": 50,
	"efficacite": 50,
	"bonheur": 50,
	"science": 50
}

var environnement = {
	"night" : false,
	"temperature": -25 - (randi() % 14),  # °C
	"saison": "Été austral"
}

var tour = 0       # chaque tours 3 mois
