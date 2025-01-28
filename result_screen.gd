extends Control

@onready var result_title: Label = $PanelContainer/PanelContainer/MarginContainer/VBoxContainer/ResultTitle
@onready var gold_text: Label = $"PanelContainer/PanelContainer/MarginContainer/VBoxContainer/+Gold"
@export var combat_manager : Node
signal continue_pressed
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_text(result, gold):
	result_title.text = result
	if gold > 0:
		gold_text.text = "+" + str(gold) + " Gold"
	else:
		gold_text.text = ""
	if result == "Defeat!":
		gold_text.text = "Better luck next time.."
		


func _on_continue_pressed() -> void:
	continue_pressed.emit()
