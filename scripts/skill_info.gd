extends Control

@export var skill : Skill
@onready var skill_name: Label = $PanelContainer/PanelContainer/MarginContainer/VBoxContainer/SkillName
@onready var element: Label = $PanelContainer/PanelContainer/MarginContainer/VBoxContainer/Element
@onready var description: Label = $PanelContainer/PanelContainer/MarginContainer/VBoxContainer/Description

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	description.text = ""


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
	
	if skill.damaging == true:
		description.text += "Deals " + str(skill.damage) + " " + str(skill.element) + " damage\nto " + target
	if skill.unique == "Flameburst":
		description.text += " per fire reaction occured this fight\nTotal damage: " + str(skill.final_damage)
		
	if skill.shielding == true:
		description.text += "Shields " + str(skill.damage) + " to " + target
	if skill.healing == true:
		description.text += "Heals " + str(skill.damage) + " to " + target
	
	if description.text == "" and skill.element != "none":
		description.text = "Applies " + skill.element + " to " + target
	if skill.double_hit == true:
		description.text += "\nThen, deals " + str(skill.damage2) + " " + str(skill.element2) + " damage\nto the same target(s)"
	if skill.requirement == true:
		description.text += "\nRequires " + str(skill.requirement_count) + " " + skill.reaction_requirement + " procs to use"
	
