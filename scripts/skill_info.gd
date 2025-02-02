extends Control

@export var skill : Skill
@onready var skill_name: RichTextLabel = %SkillName
@onready var element: RichTextLabel = %Element
@onready var description: Label = %Description


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	description.text = ""

func update_skill_info():
	description.text = ""
	var target = ""
	skill_name.text = "[center]" + skill.name + "[/center]"
	var element_text = ""
	match skill.element:
		"fire":
			element_text = "[color=coral]Fire[/color]"
		"water":
			element_text = "[color=dark_cyan]Water[/color]"
		"lightning":
			element_text = "[color=purple]Lightning[/color]"
		"grass":
			element_text = "[color=web_green]Grass[/color]"
		"earth":
			element_text = "[color=saddle_brown]Earth[/color]"
		
	element.text = "[center]" + element_text + "[/center]"
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
		"random_enemy":
			target = "a random enemy"
		"random_ally":
			target = "a random ally"
	
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
	if skill.status_effects != []:
		for x in skill.status_effects:
			if x.name == "Bleed":
				description.text += "\nApplies Bleed on targets"
			if x.name == "Burn":
				description.text += "\nApplies Burn on targets"
			if x.name == "Bubble":
				description.text += "\nApplies Bubble on targets"
			if x.name == "Muck":
				description.text += "\nApplies Muck on targets"
			if x.name == "Nitro":
				description.text += "\nApplies Nitro on targets"
			if x.name == "Sow":
				description.text += "\nApplise Sow on targets"
	if skill.cost > 0:
		description.text += "\nCosts " +  str(skill.cost) + " " + skill.token_type + " tokens"
		if skill.cost2 > 0:
			description.text += "\nand " + str(skill.cost2) + " " + skill.token_type2 + " tokens to use"
		else:
			description.text += " to use"
	
