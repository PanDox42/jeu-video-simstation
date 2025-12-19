## CropBar - Barre de progression visuelle pour les statistiques
##
## Affiche une barre de remplissage qui représente visuellement un pourcentage.
## Utilisé pour montrer la santé, l'efficacité et le bonheur de la population.
## Se met à jour automatiquement chaque frame selon son nom de nœud.
extends Sprite2D

## Met à jour la région visible de la barre selon une valeur (0-100)
## @param value: Pourcentage à afficher (0-100)
func _update_bar(value: int):
	var ratio = value / 100.0
	region_enabled = true
	region_rect = Rect2(33.999, 45.353, ratio * 83.872, 54.51)

## Met automatiquement à jour la barre selon son nom de nœud
## Supporte: SpriteFilledBarHealth, SpriteFilledBarEfficiency, SpriteFilledBarHappiness
## @param _delta: Delta time
func _process(_delta):
	match name: # name c'est le name du truc appelant
		"SpriteFilledBarHealth":
			_update_bar(GlobalScript.get_health())
		"SpriteFilledBarEfficiency":
			_update_bar(GlobalScript.get_efficiency())
		"SpriteFilledBarHappiness":
			_update_bar(GlobalScript.get_hapiness())
		_: # default
			print ("Erreur : Pas le bon appelant")
