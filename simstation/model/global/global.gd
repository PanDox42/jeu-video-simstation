## Global Singleton pour SimStation
##
## Autoload global qui gère toutes les données persistantes de la partie courante.
## Ce singleton stocke l'état complet du jeu : joueur, population, bâtiments,
## ressources, statistiques et environnement.
##
## @tutorial: https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
extends Node

# === ÉTAT DU JEU ===

## Active ou désactive le mouvement de la caméra
var camera_enable = true

## Indique si un bâtiment est actuellement en cours de placement sur la carte
var currently_placing = false

## Données du joueur contenant le nom et le temps de jeu
## Format: {"name": String, "time": int}
var user = {"name":"Martin","time":3}

# === POPULATION ===

## Liste des habitants de la station avec leurs statistiques individuelles
## Chaque habitant a : health (santé 0-100), efficiency (efficacité 0-100), happiness (bonheur 0-100)
var population = [
	{"health": 100, "efficiency": 100, "happiness": 50}
]

# === SYSTÈME DE RECHERCHE ===

## Liste des noms de recherches déjà débloquées par le joueur
var search_unblocked = []

## Recherches en cours avec leur round de fin
## Format: {"nom_recherche": round_de_fin}
var research_in_progress = {}

# === ÉCONOMIE ===

## Crédits disponibles pour acheter des bâtiments et des recherches
var money = 3000000

# === INVENTAIRE DES BÂTIMENTS ===

## Inventaire des bât

iments possédés par le joueur (non encore placés)
## Quantité de chaque type de bâtiment disponible
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

## Bâtiments placés sur la carte avec leur état
## Clé: ID du nœud | Valeur: {type: String, temp: int (température interne), health: int (santé 0-100)}
var buildings_place = {
	# id : {type, temp, health}
}

## Données statiques de tous les types de bâtiments disponibles
## Format par bâtiment: [Bonus_Bonheur, Description, Nom_Affichage, Débloqué, Prix_Crédits, Consommation_Énergie]
## 
## **Bâtiments de base** (débloqués par défaut):
## - labo: Laboratoire de recherche scientifique
## - dormitory: Dortoir pour le repos de l'équipe
## - boiler_room: Chaufferie centrale pour chauffer tous les bâtiments
## 
## **Infrastructure** (à débloquer):
## - gym: Salle de sport pour la condition physique
## - canteen: Cantine pour la nourriture chaude
## - rest_room: Salle de repos pour la détente
## 
## **Science** (à débloquer):
## - hospital: Hôpital pour soigner les maladies graves
## - observatory: Observatoire pour la recherche astronomique
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

# === STATISTIQUES GLOBALES ===

## Statistiques moyennes de la station (calculées depuis la population)
## - health: Santé moyenne (0-100)
## - efficiency: Efficacité moyenne (0-100, calculée: health*0.6 + happiness*0.4)
## - happiness: Bonheur moyen (0-100)
## - science: Niveau de progression scientifique (0-100)
var stats = {
	"health": 50,
	"efficiency": 50,
	"happiness": 50,
	"science": 50
}

# === ENVIRONNEMENT ===

## Données environnementales de l'Antarctique
## - night: Mode nuit activé ou non (bool)
## - temperature: Température extérieure en °C (varie entre -25°C et -80°C selon la saison)
## - season: Saison actuelle ("Été austral", "Automne austral", "Hiver austral", "Printemps austral")
var environnement = {
	"night" : false,
	"temperature": -25 - (randi() % 14),  # °C
	"season": "Été austral"
}

# === TEMPS ===

## Numéro du round actuel (chaque round = 3 mois dans le jeu)
## Les saisons changent tous les rounds : 0=Été, 1=Automne, 2=Hiver, 3=Printemps
var round = 0
