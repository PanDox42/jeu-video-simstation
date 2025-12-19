extends Node

# DESCRIPTION :
# Global qui sert à stocker les infos du joueur, des stats de la partie, des batiments, 
# de la population, de la money et du nombre de round de la partie.

var user = {"name":"Martin","time":3}

var camera_enable = true;
var currently_placing = false;

# Besoin d'être sauvegardé
var name_station = ""
var money = 500000

var population = [
	{"health": 100, "efficiency": 100, "happiness": 50}
]

var search_unblocked = []
var research_in_progress = {}

# ce que le joueur possède
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

var buildings_place = {
	# id : {type, position, temp, health}
}

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

var stats = {
	"health": 50,
	"efficiency": 50,
	"happiness": 50,
}

var environnement = {
	"night" : false,
	"temperature": -25 - (randi() % 14),  # °C
	"season": "Été austral"
}

var round = 0       # chaque rounds 3 mois
