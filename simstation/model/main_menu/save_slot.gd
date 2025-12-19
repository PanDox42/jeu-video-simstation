extends TextureButton

var slot_file_name = ""

signal slot_selected(file_name)

func setup(file_name, money, date):
	slot_file_name = file_name
	$LabelName.text = file_name
	
# %02d signifie : un nombre entier sur 2 chiffres, avec un zéro au début si besoin.
	$LabelDate.text = "Date:  %02d/%02d/%d  %02d:%02d:%02d" % [
		date.day, 
		date.month, 
		date.year, 
		date.hour, 
		date.minute, 
		date.second
	]

func _on_pressed():
	emit_signal("slot_selected", slot_file_name)
