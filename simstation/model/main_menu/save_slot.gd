extends Button

var slot_file_name = ""

signal slot_selected(file_name)

func setup(file_name, money, date):
	slot_file_name = file_name
	$LabelName.text = file_name
	$LabelDate.text = "Date: " + str(int(date.day)) + "/" + str(int(date.month)) + "/" + str(int(date.year))

func _on_pressed():
	emit_signal("slot_selected", slot_file_name)
