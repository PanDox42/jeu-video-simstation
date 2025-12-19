extends TextureButton

## Nom du fichier de sauvegarde (sans extension .json)
var slot_file_name = ""

## Signal émis lors de la sélection d'un slot de sauvegarde
signal slot_selected(file_name)

## Configure les informations affichées sur le slot de sauvegarde
## @param file_name: Nom du fichier de sauvegarde
## @param money: Argent disponible (non utilisé)
## @param date: Dictionnaire contenant la date de sauvegarde
func setup(file_name, money, date):
	slot_file_name = file_name
	$LabelName.text = file_name
	
# %02d signifie : un nombre entier sur 2 chiffres, avec un zéro au début si besoin.
	$LabelDate.text = "Date :  %02d/%02d/%d  %02d:%02d:%02d" % [
		date.day, 
		date.month, 
		date.year, 
		date.hour, 
		date.minute, 
		date.second
	]

## Appelé lors du clic sur le slot
## Émet le signal slot_selected avec le nom du fichier
func _on_pressed():
	emit_signal("slot_selected", slot_file_name)
