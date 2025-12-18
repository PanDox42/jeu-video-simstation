# global

**Extends:** `Node`

Global Singleton pour SimStation  Autoload global qui gère toutes les données de la partie courante. Ce singleton stocke les informations du joueur, les statistiques de la station, l'inventaire des bâtiments, l'argent disponible et l'état de l'environnement.  @tutorial: https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html

**Fichier:** `model\global\global.gd`

## Variables

### camera_enable

Active ou désactive le mouvement de la caméra

### currently_placing

Indique si un bâtiment est en cours de placement sur la carte

### user

Données du joueur (nom et temps de jeu)

### population

Liste des statistiques de la population de la station Chaque entrée contient: health (santé), efficiency (efficacité), happiness (bonheur)

### search_unblocked

Liste des recherches débloquées

### research_in_progress

Dictionnaire des recherches en cours de progression

### money

Crédits disponibles pour acheter des bâtiments et recherches

### inventory

Inventaire des bâtiments possédés par le joueur (quantité par type)

### buildings_place

Bâtiments placés sur la carte Clé: id du bâtiment, Valeur: dictionnaire {type, temp, health}

### stats

### environnement

### round
