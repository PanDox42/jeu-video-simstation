# hud

**Extends:** `CanvasLayer`

HUD - Interface principale du jeu

Gère l'affichage de toutes les informations principales : argent, date, saison, température.

Contrôle le bouton suivant pour passer au tour suivant avec cooldown de 15 secondes.

Gère l'affichage/masquage de l'inventaire, le mode nuit/jour et les notifications de catastrophe.


**Fichier:** `model\hud\hud.gd`

## Fonctions

### _ready()

Initialise le HUD et connecte les signaux

### _update_month()

Met à jour l'affichage du mois

### _update_season()

Met à jour l'affichage de la saison

### _update_temperature()

Met à jour l'affichage de la température

### _on_money_changed(new_value)

Met à jour l'affichage de l'argent

**Paramètres:**

`new_value` : Nouvelle valeur de l'argent

### _update_night_mode()

Bascule le mode nuit tous les 2 tours

### _on_next_round_pressed()

Appelé quand le bouton "Tour suivant" est pressé

### change_visible_confirmation_next_round() -> void

Bascule la visibilité du popup de confirmation

### btn_next_round_start_cooldown()

Démarre le cooldown de 15 secondes sur le bouton "Tour suivant"

### _on_btn_chart_stats_pressed() -> void

Ouvre le graphique de statistiques

### _on_close_inventory_pressed_() -> void

Bascule la visibilité de l'inventaire et change l'icône de l'œil

### charger_load_screen()

Cache l'écran de chargement après 1 seconde

### display_next_round()

Affiche l'animation de transition de tour

### display_night_filter(status : bool)

Affiche ou masque le filtre de nuit avec animation

**Paramètres:**

`status` : true pour afficher, false pour masquer

### display_night_day(status : bool)

Affiche le message "La nuit tombe" ou "Le jour se lève"

**Paramètres:**

`status` : true pour nuit, false pour jour

### display_disaster()

Affiche la notification de catastrophe si une est active
