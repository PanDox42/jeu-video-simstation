## MainMenu - Menu principal du jeu
##
## Gère la navigation du menu principal avec les options :
## Jouer, Options, Crédits, Tutoriel et Quitter.
## Charge dynamiquement les sous-menus sans les dupliquer.
extends CanvasLayer

## Scène du menu options préchargée
const MENU_OPTIONS_SCENE = preload("res://View/settings.tscn")

## Scène des crédits préchargée
const CREDITS_SCENE = preload("res://View/credits.tscn")

## Instance actuelle du menu secondaire (options ou crédits)
var menu_instance = null

## Lance la partie
## Charge la scène de jeu principale
func _on_btn_jouer_pressed() -> void:
	get_tree().change_scene_to_file("res://View/play.tscn")

## Ouvre le menu des options
## Instancie ou bascule la visibilité du menu settings
func _on_btn_options_pressed() -> void:
	if menu_instance == null:
		menu_instance = MENU_OPTIONS_SCENE.instantiate()
		get_parent().add_child(menu_instance) 
	else:
		var is_visibles = menu_instance.visible
		menu_instance.visible = not is_visibles

## Quitte le jeu
func _on_btn_quitter_pressed() -> void:
	get_tree().quit()


## Ouvre le menu des crédits
## Instancie ou bascule la visibilité de l'écran des crédits
func _on_btn_credits_pressed() -> void:
	if menu_instance == null:
		menu_instance = CREDITS_SCENE.instantiate()
		get_parent().add_child(menu_instance) 
	else:
		var is_visibles = menu_instance.visible
		menu_instance.visible = not is_visibles

## Ouvre le tutoriel
## Charge et affiche l'écran de tutoriel interactif
func _on_btn_tuto_pressed():
	var tuto_scene = load("res://View/tuto.tscn")
	var tuto_instance = tuto_scene.instantiate()
	
	add_child(tuto_instance)
