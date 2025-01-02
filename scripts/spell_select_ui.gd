extends Control

@onready var ba_1: PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/BA1Panel
@onready var sp_1: PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/SP1Panel
@onready var sp_2: PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/SP2Panel
@onready var ult: PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/ULTPanel
var unselected = Color("464646")
var selected = Color("3a4274")

func _on_ba_1_panel_mouse_entered() -> void:
	ba_1.get_theme_stylebox("normal").set_bg_color(selected)
	print("hi")





func _on_area_2d_mouse_entered() -> void:
	ba_1.get_theme_stylebox("normal").set_bg_color(selected)
	print("hi2")
