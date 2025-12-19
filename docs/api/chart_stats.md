# chart_stats

**Extends:** `Panel`

**Fichier:** `model\hud\statistics\chart_stats.gd`

## Variables

### x_spacing

Espacement horizontal entre les points de données

### y_spacing

Espacement vertical (non utilisé actuellement)

### health_line

Ligne de tracé pour les points de santé (rouge)

### hapiness_line

Ligne de tracé pour les points de bonheur (jaune)

### efficiency_line

Ligne pour l'efficacité

### x_line

Axe X (vertical à gauche)

### y_line

Axe Y (horizontal en bas)

### size_x

Conteneur interne pour le dessin (s'agrandit horizontalement)
Conteneur de scroll pour naviguer dans le graphique
Largeur du conteneur de scroll

### size_y

Hauteur du conteneur de scroll

### health_points: Array[Vector2]

Points de données pour la santé

### points_happiness: Array[Vector2]

Points de données pour le bonheur

### points_efficiency: Array[Vector2]

Points de données pour l'efficacité

## Fonctions

### _ready()

Initialise le graphique et dessine les axes

### ajouter_point_et_mettre_a_jour()

Ajoute un nouveau point pour chaque statistique et met à jour le graphique
Appelé automatiquement à chaque changement de tour

### create_marker(position: Vector2, color: Color)

Crée un marqueur visuel (losange) à une position donnée

**Paramètres:**

`position` : Position du marqueur

`color` : Couleur du marqueur

### _on_exit_button_pressed() -> void

Cache le graphique
