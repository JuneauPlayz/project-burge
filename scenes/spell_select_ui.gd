extends Control


var selected = 0
signal new_select
@export var char : int

@onready var ba_1: Button = $PanelContainer/MarginContainer/VBoxContainer/BA1Panel/ba_1
@onready var s_1: Button = $PanelContainer/MarginContainer/VBoxContainer/SP1Panel/S1
@onready var s_2: Button = $PanelContainer/MarginContainer/VBoxContainer/SP2Panel/S2
@onready var ult: Button = $PanelContainer/MarginContainer/VBoxContainer/ULTPanel/ULT
@onready var positionL : Label = $Position

var blue = Color("3f61a1")
var gray = Color("2e2e2e")


func _on_button_pressed() -> void:
	if selected != 1:
		selected = 1
	else:
		selected = 0
	update()

func _on_s_1_pressed() -> void:
	if selected != 2:
		selected = 2
	else:
		selected = 0
	update()

func _on_s_2_pressed() -> void:
	if selected != 3:
		selected = 3
	else:
		selected = 0
	update()
	
func _on_ult_pressed() -> void:
	if selected != 4:
		selected = 4
	else:
		selected = 0
	update()
	
func update():
	new_select.emit()
	match selected:
		0:
			update_color(ba_1, gray)
			update_color(s_1, gray)
			update_color(s_2, gray)
			update_color(ult, gray)
		1:
			update_color(ba_1, blue)
			update_color(s_1, gray)
			update_color(s_2, gray)
			update_color(ult, gray)
		2:
			update_color(ba_1, gray)
			update_color(s_1, blue)
			update_color(s_2, gray)
			update_color(ult, gray)
		3:
			update_color(ba_1, gray)
			update_color(s_1, gray)
			update_color(s_2, blue)
			update_color(ult, gray)
		4:
			update_color(ba_1, gray)
			update_color(s_1, gray)
			update_color(s_2, gray)
			update_color(ult, blue)
	
func update_color(button, color):
	var new_stylebox_normal = button.get_theme_stylebox("normal").duplicate()
	new_stylebox_normal.bg_color = color
	button.add_theme_stylebox_override("normal", new_stylebox_normal)
	
func update_pos(pos):
	if pos > 0:
		positionL.text = "Position: " + str(pos)
	else:
		positionL.text = "Position: "
	
func reset():
	update_color(ba_1, gray)
	update_color(s_1, gray)
	update_color(s_2, gray)
	update_color(ult, gray)
	selected = 0
	
