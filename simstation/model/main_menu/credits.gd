## Credits - Écran des crédits du jeu
##
## Affiche les crédits de l'équipe de développement.
## Simple overlay qui peut être fermé avec un bouton.
extends CanvasLayer

## Ferme l'écran des crédits
## Supprime le nœud de la scène
func _on_exit_button_pressed() -> void:
	queue_free()
