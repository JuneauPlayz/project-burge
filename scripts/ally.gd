extends Unit
class_name Ally

@export var basic_atk : Skill
@export var skill_1: Skill
@export var skill_2: Skill
@export var ult: Skill
var current_element = "none"
@onready var damage_number_origin: Node2D = $DamageNumberOrigin
@onready var spell_select_ui: Control = $SpellSelectUi
@onready var hp_bar: Control = $"HP Bar"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# spell select ui first child, hp bar ui second child
	spell_select_ui.skill1 = basic_atk
	spell_select_ui.skill2 = skill_1
	spell_select_ui.skill3 = skill_2
	spell_select_ui.skill4 = ult
	spell_select_ui.load_skills()
	
	hp_bar.set_hp(health)
	hp_bar.set_maxhp(health)


func receive_skill(damage: float, element: String):
	var rounded : int
	var reaction = ""
	var r = await ReactionManager.reaction(current_element, element, self, damage, 1)
	# no reaction
	if (!r):
		self.take_damage(damage)
		DamageNumbers.display_number(damage, damage_number_origin.global_position, element, reaction)
		# don't change current element if skill has no element
		if (element != "none"):
			current_element = element
	hp_bar.update_element(current_element)
	
func receive_skill_friendly(effect: float, element: String):
	var rounded : int
	var reaction = ""
	var r = await ReactionManager.reaction(current_element, element, self, effect, 0)
	self.receive_shielding(effect)
	DamageNumbers.display_number_plus(effect, damage_number_origin.global_position, element, reaction)
	if (element != "none"):
		current_element = element
	hp_bar.update_element(current_element)
	
	
	
func take_damage(damage : int):
	var damage_left = damage
	if (shield > 0):
		if (shield <= damage_left):
			damage_left -= shield
			shield = 0
		elif (shield > damage_left):
			shield -= damage_left
			damage_left = 0
		hp_bar.set_shield(shield)
	health -= damage_left
	hp_bar.set_hp(health)

func receive_healing(healing: int):
	health += healing
	hp_bar.set_hp(health)
	
func receive_shielding(shielding: int):
	shield += shielding
	hp_bar.set_shield(shield)

func toggle_skills():
	spell_select_ui.visible = !spell_select_ui.visible
	
func set_shield(shield):
	self.shield = shield
	hp_bar.set_shield(shield)
