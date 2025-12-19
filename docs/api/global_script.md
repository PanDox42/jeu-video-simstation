# global_script

**Extends:** `Node`

GlobalScript - Singleton utilitaire pour SimStation

Autoload qui fournit une interface complète pour accéder et modifier les données
du singleton Global. Contient tous les getters, setters et fonctions utilitaires
pour gérer l'économie, les bâtiments, les statistiques et l'environnement.


Ce script agit comme une couche d'abstraction entre le code du jeu et le Global,
et émet des signaux pour notifier les changements d'état.


**Fichier:** `model\global\global_script.gd`

## Fonctions

### get_health() -> int

Récupère la santé moyenne de la station

**Retourne:** Valeur de santé (0-100)

### get_efficiency() -> int

Récupère l'efficacité moyenne de la station

**Retourne:** Valeur d'efficacité (0-100)

### get_hapiness() -> int

Récupère le bonheur moyen de la station

**Retourne:** Valeur de bonheur (0-100)

### get_money() -> int

Récupère l'argent disponible

**Retourne:** Crédits disponibles

### get_inventory() -> Dictionary

Récupère tout l'inventaire des bâtiments

**Retourne:** Dictionnaire {nom_batiment: quantité}

### get_camera() -> bool

Récupère l'état d'activation de la caméra

**Retourne:** true si la caméra est activée

### get_round() -> int

Récupère le numéro du round actuel

**Retourne:** Numéro du round (chaque round = 3 mois)

### get_temperature() -> int

Récupère la température extérieure actuelle

**Retourne:** Température en °C (négatif)

### get_environnement(environnement)

Récupère une donnée d'environnement spécifique

**Paramètres:**

`environnement` : Clé de la donnée ("temperature", "season", "night")

**Retourne:** Valeur de la donnée demandée

### get_night_mode()

Récupère l'état du mode nuit

**Retourne:** true si le mode nuit est actif

### get_building_price(name) -> int

Récupère le prix d'achat d'un type de bâtiment

**Paramètres:**

`name` : Nom du type de bâtiment (ex: "dormitory")

**Retourne:** Prix en crédits

### get_info_building(id)

Récupère les informations d'un bâtiment placé sur la carte

**Paramètres:**

`id` : ID du nœud du bâtiment sur la carte

**Retourne:** Dictionnaire {type, temp, health} ou null si introuvable

### get_buildings_counts() -> int

Récupère le nombre total de bâtiments placés sur la carte

**Retourne:** Nombre de bâtiments

### get_buildings_place() -> Dictionary

Récupère tous les bâtiments placés sur la carte

**Retourne:** Dictionnaire {id: {type, temp, health}}

### get_buildings_data() -> Dictionary

Récupère toutes les données statiques des types de bâtiments

**Retourne:** Dictionnaire complet de buildings_info

### get_buildings_unblocked(building_name) -> bool

Vérifie si un type de bâtiment est débloqué

**Paramètres:**

`building_name` : Nom du type de bâtiment

**Retourne:** true si débloqué

### get_building_hapiness(building_name)

Récupère le bonus de bonheur d'un type de bâtiment

**Paramètres:**

`building_name` : Nom du type de bâtiment

**Retourne:** Valeur du bonus de bonheur

### get_building_description(building_name)

Récupère la description d'un type de bâtiment

**Paramètres:**

`building_name` : Nom du type de bâtiment

**Retourne:** Texte de description

### get_building_display_name(building_name)

Récupère le nom d'affichage d'un type de bâtiment

**Paramètres:**

`building_name` : Nom du type de bâtiment (clé interne)

**Retourne:** Nom lisible pour l'interface (ex: "Dortoir")

### get_building_false_name_by_id(building_id)

Récupère le type d'un bâtiment placé via son ID

**Paramètres:**

`building_id` : ID du bâtiment sur la carte

**Retourne:** Type du bâtiment (ex: "dormitory")

### get_size_building(building_name)

Récupère la consommation énergétique d'un type de bâtiment

**Paramètres:**

`building_name` : Nom du type de bâtiment

**Retourne:** Consommation en watts

### get_building_inventory(nameBat) -> int

Récupère la quantité d'un type de bâtiment dans l'inventaire

**Paramètres:**

`nameBat` : Nom du type de bâtiment

**Retourne:** Quantité disponible

### get_population() -> Array

Récupère la liste complète de la population

**Retourne:** Tableau d'habitants avec leurs stats

### get_research_in_progress() -> Dictionary

Récupère les recherches actuellement en cours

**Retourne:** Dictionnaire {nom_recherche: round_de_fin}

### get_search_unblocked() -> Array

Récupère la liste des recherches déjà débloquées

**Retourne:** Tableau de noms de recherches

### get_currently_placing()

Récupère l'état de placement de bâtiment

**Retourne:** true si un bâtiment est en cours de placement

### get_save_data()

### get_name_station()

### set_health(val)

Définit la santé moyenne de la station

**Paramètres:**

`val` : Nouvelle valeur (0-100)

### set_efficiency(val)

Définit l'efficacité moyenne de la station

**Paramètres:**

`val` : Nouvelle valeur (0-100)

### set_hapiness(val)

Définit le bonheur moyen de la station

**Paramètres:**

`val` : Nouvelle valeur (0-100)

### set_money(val)

Définit l'argent disponible

**Paramètres:**

`val` : Nouvelle quantité de crédits

### set_camera(val)

Définit l'état d'activation de la caméra

**Paramètres:**

`val` : true pour activer la caméra

### set_night_mode(active : bool)

Définit l'activation du mode nuit

**Paramètres:**

`active` : true pour activer le mode nuit

### set_temperature(val: int)

Définit la température extérieure

**Paramètres:**

`val` : Nouvelle température en °C

### set_season(saison : String)

Définit la saison actuelle

**Paramètres:**

`saison` : Nom de la saison ("Été austral", etc.)

### set_currently_placing(placing: bool)

Définit l'état de placement de bâtiment

**Paramètres:**

`placing` : true si un bâtiment est en cours de placement

### set_research_in_progress(search_name, end_round)

Enregistre une recherche en cours avec son round de fin

**Paramètres:**

`search_name` : Nom de la recherche

`end_round` : Numéro du round où elle sera terminée

### set_inventory(inventory)

### set_stats(stats)

### set_environement(environment)

### set_round(round)

### set_search_unblocked(unblocked)

### set_name_station(new_name_station)

### set_batiment_place(new_bat_place)

### set_batiment_info(new_bat_info)

### set_building_unblocked(name: String)

Débloque un type de bâtiment

**Paramètres:**

`name` : Nom du type de bâtiment à débloquer

### add_search_unblocked(search_name)

Ajoute une recherche à la liste des recherches débloquées

**Paramètres:**

`search_name` : Nom de la recherche à ajouter

### ass_research_in_progress(search_name)

Ajoute une recherche en cours (DEPRECATED - typo dans le nom)

**Paramètres:**

`search_name` : Nom de la recherche

### add_building(id_node: int, type: String, position:Vector2)

Place un nouveau bâtiment sur la carte

**Paramètres:**

`id_node` : ID du nœud sur la carte

`type` : Type du bâtiment (ex: "dormitory")

### erase_research_in_progress(search_name)

Retire une recherche de la liste des recherches en cours

**Paramètres:**

`search_name` : Nom de la recherche à retirer

### has_search(name: String) -> bool

Vérifie si une recherche est déjà débloquée

**Paramètres:**

`name` : Nom de la recherche

**Retourne:** true si la recherche est débloquée

### edit_money(delta: int) -> void

Modifie l'argent du joueur (ajoute ou retire)
Émet le signal money_changed

**Paramètres:**

`delta` : Montant à ajouter (positif) ou retirer (négatif)

### edit_building(name: String, delta: int) -> void

Modifie la quantité d'un bâtiment dans l'inventaire
Émet le signal building_changed

**Paramètres:**

`name` : Type de bâtiment

`delta` : Quantité à ajouter (positif) ou retirer (négatif)

### update_population_stats(health: float, hapiness: float, efficiency: float) -> void

Met à jour les statistiques de toute la population avec un lerp
Émet le signal stats_updated

**Paramètres:**

`health` : Valeur cible de santé

`hapiness` : Valeur cible de bonheur

`efficiency` : Valeur d'efficacité (appliquée directement)

### format_money(value: int) -> String

Formate un nombre en ajoutant des espaces tous les 3 chiffres

**Paramètres:**

`value` : Nombre à formater

**Retourne:** String formaté (ex: "1 234 567")

### play_sound(sound_path: String)

Joue un son en créant un AudioStreamPlayer temporaire
Le player se supprime automatiquement à la fin du son

**Paramètres:**

`sound_path` : Chemin vers le fichier audio (ex: "res://sounds/click.ogg")

### generate_fade_display(start_fade_time, end_fade_time, display_time, element)

Crée une animation de fade-in/fade-out pour un élément UI
Utile pour afficher temporairement des notifications

**Paramètres:**

`start_fade_time` : Durée de l'apparition en secondes

`end_fade_time` : Durée de la disparition en secondes

`display_time` : Durée d'affichage en secondes

`element` : Nœud UI à animer (doit avoir modulate.a)
