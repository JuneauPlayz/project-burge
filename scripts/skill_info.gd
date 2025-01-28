extends Control

@export var skill : Skill
@onready var skill_name: Label = $PanelContainer/PanelContainer/MarginContainer/VBoxContainer/SkillName
@onready var element: Label = $PanelContainer/PanelContainer/MarginContainer/VBoxContainer/Element
@onready var description: Label = $PanelContainer/PanelContainer/MarginContainer/VBoxContainer/Description

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	description.text = ""



func update_skill_info():
	description.text = ""
	var target = ""
	skill_name.text = skill.name
	element.text = skill.element
	match skill.target_type:
		"single_enemy":
			target = "an enemy"
		"single_ally":
			target = "an ally"
		"all_allies":
			target = "all allies"
		"all_enemies":
			target = "all enemies"
		"all_units":
			target = "all units"
		"front_ally":
			target = "the front ally"
		"front_enemy":
			target = "the front enemy"
		"back_ally":
			target = "the back ally"
		"back_enemy":
			target = "the back enemy"
	
	if skill.damaging == true:
		description.text += "Deals " + str(skill.damage) + " " + str(skill.element) + " damage\nto " + target
		
	if skill.shielding == true:
		description.text += "Shields " + str(skill.damage) + " to " + target
	if skill.healing == true:
		description.text += "Heals " + str(skill.damage) + " to " + target
	
	if description.text == "" and skill.element != "none":
		description.text = "Applies " + skill.element + " to " + target
	if skill.double_hit == true:
		description.text += "\nThen, deals " + str(skill.damage2) + " " + str(skill.element2) + " damage\nto the same target(s)"
	if skill.cost > 0:
		description.text += "\nCosts " +  str(skill.cost) + " " + skill.token_type + " tokens"
		if skill.cost2 > 0:
			description.text += "\nand " + str(skill.cost2) + " " + skill.token_type2 + " tokens to use"
		else:
			description.text += " to use"
	
