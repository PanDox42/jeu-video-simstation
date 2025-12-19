## ChartStats - Graphique des statistiques de la station
##
## Affiche un graphique linéaire montrant l'évolution des 3 statistiques principales :
## Santé (rouge), Bonheur (jaune), Efficacité (bleu).
## Ajoute automatiquement un point à chaque tour et fait défiler horizontalement.
extends CanvasLayer
 
## Espacement horizontal entre les points (augmente à chaque tour)
var x_spacing = 10

## Espacement vertical de base
var y_spacing = 10

## Ligne pour la santé
var health_line = Line2D.new()

## Ligne pour le bonheur
var hapiness_line = Line2D.new()

## Ligne pour l'efficacité
var efficiency_line = Line2D.new()

## Axe X (vertical à gauche)
var x_line = Line2D.new()

## Axe Y (horizontal en bas)
var y_line = Line2D.new()

## Conteneur interne pour le dessin (s'agrandit horizontalement)
@onready var internal_container = Control.new()

## Conteneur de scroll pour naviguer dans le graphique
@onready var scrollContainer = $PanelChartStats/ScrollStatistics

## Largeur du conteneur de scroll
var size_x

## Hauteur du conteneur de scroll
var size_y

## Points de données pour la santé
var health_points: Array[Vector2] = []

## Points de données pour le bonheur
var points_happiness: Array[Vector2] = []

## Points de données pour l'efficacité
var points_efficiency: Array[Vector2] = []

## Initialise le graphique et dessine les axes
func _ready():
	await get_tree().process_frame
	size_x = scrollContainer.size.x
	size_y = scrollContainer.size.y
	
	x_line.width = 5
	x_line.default_color = Color.GRAY
	var points_x: Array[Vector2] = [Vector2(8,5), Vector2(8, size_y-5)]
	x_line.set_points(points_x)
	internal_container.add_child(x_line)
	
	y_line.width = 5
	y_line.default_color = Color.GRAY
	var points_y: Array[Vector2] = [Vector2(5, size_y-5), Vector2(size_x, size_y-5)]
	y_line.set_points(points_y)
	internal_container.add_child(y_line)
	
	ajouter_point_et_mettre_a_jour()
	GlobalScript.connect("round_changed", ajouter_point_et_mettre_a_jour)
	
	health_line.width = 4
	health_line.default_color = Color.RED
	hapiness_line.width = 4
	hapiness_line.default_color = Color.YELLOW
	efficiency_line.width = 4
	efficiency_line.default_color = Color.BLUE
	
	internal_container.add_child(health_line)
	internal_container.add_child(hapiness_line)
	internal_container.add_child(efficiency_line)
	
	scrollContainer.add_child(internal_container)

## Ajoute un nouveau point pour chaque statistique et met à jour le graphique
## Appelé automatiquement à chaque changement de tour
func ajouter_point_et_mettre_a_jour():
	var new_health = GlobalScript.get_health()
	var new_hapiness = GlobalScript.get_hapiness()
	var new_efficiency = GlobalScript.get_efficiency()
	
	var y_health = size_y - ((new_health * size_y) / 100.0)
	var y_efficacy = size_y - ((new_efficiency * size_y) / 100.0)
	var y_bonheur = size_y - ((new_hapiness * size_y) / 100.0)
	
	var health_position = Vector2(x_spacing, y_health - y_spacing)
	var efficiency_position = Vector2(x_spacing, y_efficacy - y_spacing)
	var health_hapiness = Vector2(x_spacing, y_bonheur - y_spacing)
	
	health_points.append(health_position)
	points_efficiency.append(efficiency_position)
	points_happiness.append(health_hapiness)
	
	x_spacing += 100
	
	internal_container.custom_minimum_size.x = x_spacing + 50
	
	if(internal_container.custom_minimum_size.x>=size_x):
		y_line.set_point_position(1, Vector2(internal_container.custom_minimum_size.x, size_y - 5))
	
	health_line.set_points(health_points)
	hapiness_line.set_points(points_happiness)
	efficiency_line.set_points(points_efficiency)
	
	create_marker(health_position, Color.RED)
	create_marker(efficiency_position, Color.BLUE)
	create_marker(health_hapiness, Color.YELLOW)
	
	scrollContainer.scroll_horizontal = int(internal_container.custom_minimum_size.x)

## Crée un marqueur visuel (losange) à une position donnée
## @param position: Position du marqueur
## @param color: Couleur du marqueur
func create_marker(position: Vector2, color: Color):
	var marker = Polygon2D.new()
	
	marker.polygon = PackedVector2Array([
		Vector2(0, -6), 
		Vector2(6, 0), 
		Vector2(0, 6), 
		Vector2(-6, 0)
	])
	
	marker.position = position
	marker.color = color
	marker.z_index = 1 
	
	internal_container.add_child(marker)

## Cache le graphique
func _on_exit_button_pressed() -> void:
	hide()
