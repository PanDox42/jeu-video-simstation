extends Sprite2D

func _update_bar(value: int):
	var ratio = value / 100.0
	region_enabled = true
	region_rect = Rect2(33.999, 45.353, ratio * 83.872, 54.51)

func _process(_delta):
	match name: # name c'est le nom du truc appelant
		"SpriteFilledBarHealth":
			_update_bar(GlobalScript.get_sante())
		"SpriteFilledBarEfficiency":
			_update_bar(GlobalScript.get_efficacite())
		"SpriteFilledBarHappiness":
			_update_bar(GlobalScript.get_bonheur())
		_: # default
			print ("Erreur : Pas le bon appelant")
