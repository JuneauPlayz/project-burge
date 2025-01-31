extends Control

@onready var relic_name: Label = $PanelContainer/PanelContainer/MarginContainer/VBoxContainer/RelicName
@onready var description: Label = $PanelContainer/PanelContainer/MarginContainer/VBoxContainer/Description

#@export var relic : Relic
func _ready() -> void:
	relic_name.text = ""
	description.text = ""


func update_relic_info(relic):
	if relic != null:
		relic_name.text = relic.relic_name
		description.text = relic.tooltip
