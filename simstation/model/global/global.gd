extends Node

# DESCRIPTION :
# Global qui sert à stocker les infos du joueur, des stats de la partie, des batiments, 
# de la population, de l'money et du namebre de round de la partie.

var camera_enable = true;
var currently_placing = false;
var user = {"name":"Martin","time":3}

var population = [
	{"health": 100, "efficiency": 100, "happiness": 50}
]

var search_unblocked = []
var research_in_progress = {}

var money = 3000000

# ce que le joueur possède
var inventory = {
	"labo": 1, 
	"dormitory": 2, 
	"boiler_room": 1, 
	"canteen": 0, 
	"hospital": 1,
	"observatory" : 0,
	"gym": 0, 
	"rest_room": 0, 
}

var buildings_place = {
	# id : {type, temp, health}
}

var buildings_info = {
	# [ Bonheur, Description, name (à afficher), Débloqué ou pas, price ]
	
	# --- Bâtiments de base (Débloqués par défaut) ---
	"labo": [0, "Permet de faire des recherches scientifiques", "Laboratoire", true, 646463, 384],
	"dormitory": [60, "Permet de se reposer tranquillement", "Dortoir", true, 54867, 128],
	"boiler_room": [60, "Chauffe tous les batiments de la station", "Chaufferie", true, 54867, 384],
	
	# --- Bâtiments à débloquer via l'Arbre "Infrastructure" ---
	"gym": [70, "Améliore la condition physique des habitants", "Salle de sport", false, 957376, 128],
	"canteen": [70, "Fournit de la nourriture chaude", "Cantine", false, 50000, 256],
	"rest_room": [60, "Endroit calme pour se détendre", "Salle de repos", false, 75743, 256],
	
	# --- Bâtiments à débloquer via l'Arbre "Science" ---
	"hospital": [60, "Permet de soigner les malades graves", "Hopital", true, 100000, 256],
	"observatory" : [50, "Permet de découvrir de nouvelles étoiles", "Observatoire", false, 100000, 384],
}

var stats = {
	"health": 50,
	"efficiency": 50,
	"happiness": 50,
	"science": 50
}

var environnement = {
	"night" : false,
	"temperature": -25 - (randi() % 14),  # °C
	"season": "Été austral"
}

var round = 0       # chaque rounds 3 mois
