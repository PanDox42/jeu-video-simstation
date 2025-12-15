extends Node

# DESCRIPTION :
# Global qui sert à stocker les infos du joueur, des stats de la partie, des batiments, 
# de la population, de l'argent et du nombre de tour de la partie.

var camera_enable = true;
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
	"dortoir": 0, 
	"cantine": 1, 
	"hopital": 1,
	"observatoire" : 0,
	"salle_sport": 0, 
	"salle_repos": 0, 
}

var batiments_prix = {
	"labo_recherche": 646463, 
	"dortoir": 54867, 
	"cantine": 50000, 
	"hopital": 100000,
	"observatoire" : 100000,
	"salle_sport": 957376, 
	"salle_repos": 75743, 
}

var batiments_nombre = {
	"labo_recherche": 0, 
	"dortoir": 0, 
	"cantine": 0, 
	"hopital": 0,
	"observatoire" : 0,
	"salle_sport": 0, 
	"salle_repos": 0, 
}

 # [ Santé, Bonheur, Description, Nom (à afficher), Débloqué ou pas ]
var info_batiments = {
	# [ Santé, Bonheur, Description, Nom (à afficher), Débloqué ou pas ]
	# --- Bâtiments de base (Débloqués par défaut) ---
	"labo_recherche": [-20, -10, "Permet de faire des recherches scientifiques", "Laboratoire de recherche", true],
	"dortoir": [60, 60, "Permet de se reposer tranquillement", "Dortoir", true],
	
	# --- Bâtiments à débloquer via l'Arbre "Infrastructure" ---
	"salle_sport": [70, 70, "Améliore la condition physique des habitants", "Salle de sport", false],
	"cantine": [60, 70, "Fournit de la nourriture chaude", "Cantine", false],
	"salle_repos": [40, 60, "Endroit calme pour se détendre", "Salle de repos", false],
	
	# --- Bâtiments à débloquer via l'Arbre "Science" ---
	"hopital": [40, 60, "Permet de soigner les malades graves", "Hopital", false],
	"observatoire" : [20, 50, "Permet de découvrir de nouvelles étoiles", "Observatoire", false],
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
