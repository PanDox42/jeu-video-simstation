## GameManager - Contrôleur principal du jeu
##
## Singleton qui gère l'état global du jeu, incluant la référence à la carte courante,
## le zoom de la caméra et le chemin du bâtiment en cours de placement.
extends Node

## Référence vers la carte actuellement active dans la scène
var current_map: Node = null

## Niveau de zoom actuel de la caméra
var zoom_cam: Vector2

## Référence vers le nœud du bâtiment en cours de placement
var path_building: Node

## Définit la carte actuellement active
## @param map: Le nœud de la carte à définir comme carte courante
func set_current_map(map: Node):
	current_map = map

## Récupère la carte actuellement active
## @return: Le nœud de la carte courante
func get_current_map() -> Node:
	return current_map
	
## Définit le niveau de zoom de la caméra
## @param current_zoom_cam: Vecteur représentant le niveau de zoom (x, y)
func set_current_zoom_cam(current_zoom_cam : Vector2):
	zoom_cam = current_zoom_cam

## Récupère le niveau de zoom actuel de la caméra
## @return: Le vecteur de zoom actuel
func get_zoom_cam() -> Vector2:
	return zoom_cam
	
## Ouvre l'interface de l'arbre de recherche
## Charge et affiche la scène de l'arbre de recherche dans le HUD
func open_search():
	load_scene("res://View/search_tree.tscn", "ArbreRecherche")
	
## Charge dynamiquement une scène dans le HUD
## Si la scène existe déjà, bascule sa visibilité au lieu de la recharger
## @param chemin_scene: Chemin vers le fichier .tscn à charger
## @param name_node: Nom à donner au nœud instancié
func load_scene(chemin_scene, name_node):
	var arbre_scene = load(chemin_scene)
	var play_scene = get_tree().current_scene
	var hud = play_scene.get_node("hud") 

	if not hud.has_node(name_node):
		var instance = arbre_scene.instantiate()
		instance.name = name_node
		hud.add_child(instance)
	else:
		var node = hud.get_node(name_node)
		node.visible = !node.visible  

	GlobalScript.set_camera(!GlobalScript.get_camera())

func save_game(slot_name: String):
	var path = "user://" + slot_name + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		var data = GlobalScript.get_save_data()
		data["slot_name"] = slot_name # On stocke le nom à l'intérieur
		data["save_date"] = Time.get_datetime_dict_from_system() # Pour l'affichage
		
		file.store_string(JSON.stringify(data))
		print("Sauvegardé dans : ", path)
		
func has_save_files() -> bool:
	var dir = DirAccess.open("user://")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			# Si on trouve au moins un fichier JSON, il y a une sauvegarde
			if not dir.current_is_dir() and file_name.ends_with(".json"):
				return true
			file_name = dir.get_next()
			
	return false # Aucun fichier trouvé
	
func setup_new_game():
	GlobalScript.set_name_station("")
	GlobalScript.set_money(500000)
	GlobalScript.set_inventory({"labo": 1, "dormitory": 1, "boiler_room": 1, "canteen": 1, "hospital": 1, "gym": 0, "observatory": 0})
	GlobalScript.set_stats({
		"health": 50,
		"efficiency": 50,
		"happiness": 50,
	})
	GlobalScript.set_environement({
		"night" : false,
		"temperature": -25 - (randi() % 14),
		"season": "Été austral"
	})
	GlobalScript.set_round(0)
	GlobalScript.set_search_unblocked([])
	GlobalScript.set_batiment_place({})
	GlobalScript.set_batiment_info({
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
	})
	
func get_latest_save_file() -> String:
	var latest_file = ""
	var latest_time = 0
	
	var dir = DirAccess.open("user://")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".json"):
				var full_path = "user://" + file_name
				# On récupère l'heure de modification (en secondes)
				var modification_time = FileAccess.get_modified_time(full_path)
				
				# Si ce fichier est plus récent que le précédent trouvé
				if modification_time > latest_time:
					latest_time = modification_time
					latest_file = file_name
			
			file_name = dir.get_next()
	
	# Renvoie le nom du fichier (ex: "ma_base.json") ou une chaîne vide si rien trouvé
	return latest_file
	
func load_game(slot_name: String):
	var path = "user://" + slot_name + ".json"
	if not FileAccess.file_exists(path):
		print("Aucune sauvegarde trouvée.")
		return

	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	var data = JSON.parse_string(content)

	if data:
		GlobalScript.set_money(data["money"])
		GlobalScript.set_inventory(data["inventory"])
		GlobalScript.set_stats(data["stats"])
		GlobalScript.set_environement(data["environment"])
		GlobalScript.set_round(data["round"])
		GlobalScript.set_search_unblocked(data["unblocked"])
		GlobalScript.set_batiment_place(data["bat_place"])
		GlobalScript.set_batiment_info(data["bat_info"])
		GlobalScript.set_name_station(data["station_name"])
		print("Données de la station chargées !")
	else:
		print("Erreur de lecture de la sauvegarde.")
