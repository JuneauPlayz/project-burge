extends Control

@export var skill : Skill
@onready var skill_name: Label = $PanelContainer/MarginContainer/VBoxContainer/SkillName
@onready var element: Label = $PanelContainer/MarginContainer/VBoxContainer/Element
@onready var description: Label = $PanelContainer/MarginContainer/VBoxContainer/Description

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_skill_info():
	skill_name.text = skill.name
	element.text = skill.element
	if skill.damaging == true:
		description.text = "Deals " + str(skill.damage) + " " + str(skill.element) + " damage"
	
