# game_end_manager

**Extends:** `Node`

GameEndManager - Gestionnaire de fin de partie

Vérifie les conditions de victoire et de défaite à chaque tour.

Conditions de victoire : 20 rounds + toutes recherches + stats >40%
Conditions de défaite : Une stat atteint 0 OU échec au round 20

**Fichier:** `controller\game_end_manager.gd`

## Fonctions

### check_end_conditions()

Émis quand le joueur gagne
Émis quand le joueur perd
Round final pour la victoire/défaite
Seuil minimum pour les statistiques (victoire)
Nombre total de recherches dans le jeu
Vérifie les conditions de fin de partie
Appelé automatiquement à chaque changement de round

**Paramètres:**

`reason` : Raison de la défaite

### _check_victory_conditions() -> bool

Vérifie si toutes les conditions de victoire sont remplies

**Retourne:** true si victoire, false sinon
