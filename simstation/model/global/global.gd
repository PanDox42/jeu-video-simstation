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

# Besoin d'être sauvegardé
var name_station = ""
## Crédits disponibles pour acheter des bâtiments et des recherches
var money = 500000


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

# === INVENTAIRE DES BÂTIMENTS ===

## Inventaire des bât

## Bâtiments possédés par le joueur (pas encore placés)
## Quantité de chaque type de bâtiment disponible
var inventory = {
	"labo": 1, 
	"dormitory": 1,
	"boiler_room": 0,
	"canteen": 0, 
	"hospital": 0,
	"observatory": 0,
	"gym": 0, 
	"rest_room": 0, 
}

## Bâtiments placés sur la carte avec leur état
## Clé: ID du nœud | Valeur: {type: String, temp: int (température interne), health: int (santé 0-100)}
var buildings_place = {
	# id : {type, position, temp, health}
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
	# Index : [ Bonheur, Description, Nom, Débloqué, Prix (Crédits), Consommation/Énergie ]
	
	# --- Bâtiments de base ---
	"labo": [5, "Analyse des carottes de glace et météorites.", "Laboratoire", true, 1200000, 384],
	"dormitory": [40, "Cabines isolées avec protection thermique renforcée.", "Dortoir", true, 450000, 256],
	"hospital": [60, "Indispensable pour traiter l'hypothermie et les engelures.", "Unité\nMédicale", false, 850000, 256],
	
	# --- Infrastructure (Vital) ---
	"boiler_room": [20, "Générateur thermique central à cogénération.", "Chaufferie\nCentrale", false, 750000, 384],
	
	# --- Confort & Survie (À débloquer) ---
	"canteen": [50, "Cuisine industrielle capable de stocker 2 ans de vivres.", "Réfectoire", false, 600000, 256],
	"gym": [70, "Essentiel pour lutter contre l'atrophie musculaire en hivernage.", "Module\nSportif", false, 350000, 256],
	"rest_room": [80, "Zone de détente avec simulateur de lumière solaire.", "Salon de détente", false, 250000, 256],

	# --- Haute Technologie ---
	"observatory": [100, "Télescope infrarouge profitant de la pureté de l'air polaire.", "Observatoire", false, 2500000, 384],
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
## Les saisons changent tous les rounds
var round = 0
