extends Control
@onready var vaporize_mult: Label = $PanelContainer/MarginContainer/VBoxContainer/Control/VaporizeMult
@onready var shock_mult: Label = $PanelContainer/MarginContainer/VBoxContainer/Control2/ShockMult
@onready var detonate_mult: Label = $PanelContainer/MarginContainer/VBoxContainer/Control3/DetonateMult
@onready var erupt_mult: Label = $PanelContainer/MarginContainer/VBoxContainer/Control4/EruptMult
@onready var bloom_healing: Label = $PanelContainer/MarginContainer/VBoxContainer/Control5/BloomHealing
@onready var page_1: VBoxContainer = $PanelContainer/MarginContainer/Page1
@onready var page_2: VBoxContainer = $PanelContainer/MarginContainer/Page2
@onready var current_page_label: Label = $CurrentPage

var current_page = 1
var first_page = 1
var last_page = 2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	page_1.visible = true
	page_2.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_hide_pressed() -> void:
	get_parent().pressed.emit()


func _on_previous_page_pressed() -> void:
	if current_page != first_page:
		current_page -= 1
		change_page(current_page)


func _on_next_page_pressed() -> void:
	if current_page != last_page:
		current_page += 1
		change_page(current_page)

func change_page(page):
	current_page_label.text = "Page " + str(page)
	match page:
		1:
			page_1.visible = true
			page_2.visible = false
		2:
			page_1.visible = false
			page_2.visible = true
