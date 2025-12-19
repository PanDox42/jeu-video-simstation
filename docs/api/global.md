# global

**Extends:** `Node`

Global Singleton pour SimStation

Autoload global qui gère toutes les données persistantes de la partie courante.

Ce singleton stocke l'état complet du jeu : joueur, population, bâtiments,
ressources, statistiques et environnement.


@tutorial: https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html

**Fichier:** `model\global\global.gd`

## Variables

### camera_enable

Active ou désactive le mouvement de la caméra

### currently_placing

Indique si un bâtiment est actuellement en cours de placement sur la carte

### user

Données du joueur contenant le nom et le temps de jeu
Format: {"name": String, "time": int}

### population

Liste des habitants de la station avec leurs statistiques individuelles
Chaque habitant a : health (santé 0-100), efficiency (efficacité 0-100), happiness (bonheur 0-100)

### search_unblocked

Liste des noms de recherches déjà débloquées par le joueur

### research_in_progress

Recherches en cours avec leur round de fin
Format: {"nom_recherche": round_de_fin}

### money

Crédits disponibles pour acheter des bâtiments et des recherches

### inventory

Inventaire des bât
Bâtiments possédés par le joueur (pas encore placés)
Quantité de chaque type de bâtiment disponible

### buildings_place

Bâtiments placés sur la carte avec leur état
Clé: ID du nœud | Valeur: {type: String, temp: int (température interne), health: int (santé 0-100)}

### buildings_info

Données statiques de tous les types de bâtiments disponibles
Format par bâtiment: [Bonus_Bonheur, Description, Nom_Affichage, Débloqué, Prix_Crédits, Consommation_Énergie]

**Bâtiments de base** (débloqués par défaut):
- labo: Laboratoire de recherche scientifique
- dormitory: Dortoir pour le repos de l'équipe
- boiler_room: Chaufferie centrale pour chauffer tous les bâtiments

**Infrastructure** (à débloquer):
- gym: Salle de sport pour la condition physique
- canteen: Cantine pour la nourriture chaude
- rest_room: Salle de repos pour la détente

**Science** (à débloquer):
- hospital: Hôpital pour soigner les maladies graves
- observatory: Observatoire pour la recherche astronomique

### stats

Statistiques moyennes de la station (calculées depuis la population)
- health: Santé moyenne (0-100)
- efficiency: Efficacité moyenne (0-100, calculée: health*0.6 + happiness*0.4)
- happiness: Bonheur moyen (0-100)
- science: Niveau de progression scientifique (0-100)

### environnement

Données environnementales de l'Antarctique
- night: Mode nuit activé ou non (bool)
- temperature: Température extérieure en °C (varie entre -25°C et -80°C selon la saison)
- season: Saison actuelle ("Été austral", "Automne austral", "Hiver austral", "Printemps austral")

### round

Numéro du round actuel (chaque round = 3 mois dans le jeu)
Les saisons changent tous les rounds : 0=Été, 1=Automne, 2=Hiver, 3=Printemps
