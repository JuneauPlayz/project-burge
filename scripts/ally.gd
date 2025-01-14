extends Unit
class_name Ally

@export var basic_atk : Skill
@export var skill_1: Skill
@export var skill_2: Skill
@export var ult: Skill
@export var status : Array = []
var current_element = "none"
@onready var damage_number_origin: Node2D = $DamageNumberOrigin
@onready var spell_select_ui: Control = $SpellSelectUi
@onready var hp_bar: Control = $"HP Bar"
var position = 0
var combat_manager
var connected = false

signal reaction_ended

# special status checks
var bubbled = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# loading
	await get_tree().create_timer(0.1).timeout
	# spell select ui first child, hp bar ui second child
	combat_manager = get_parent().get_parent().get_combat_manager()
	spell_select_ui.skill1 = basic_atk
	spell_select_ui.skill2 = skill_1
	spell_select_ui.skill3 = skill_2
	spell_select_ui.skill4 = ult
	spell_select_ui.load_skills()
	spell_select_ui.new_select.connect(combat_manager._on_spell_select_ui_new_select)
	hp_bar.set_hp(max_health)
	hp_bar.set_maxhp(max_health)



func receive_skill(skill):
	var rounded : int
	var reaction = ""
	if (!connected):
		ReactionManager.reaction_finished.connect(self.reaction_signal)
		connected = true
	var r = await ReactionManager.reaction(current_element, skill.element, self, skill.damage, 1)
	if (r): 
		await reaction_ended 
		if skill.double_hit == true:
			await get_tree().create_timer(0.3).timeout
			var r2 = await ReactionManager.reaction(current_element, skill.element2, self, skill.damage2, 1)
			if (r2):
				await reaction_ended 
			if (!r2):
				self.take_damage(skill.damage)
			DamageNumbers.display_number(skill.damage, damage_number_origin.global_position, skill.element, reaction)
			if (skill.element != "none"):
				current_element = skill.element
	# no reaction
	if (!r):
		self.take_damage(skill.damage)
		DamageNumbers.display_number(skill.damage, damage_number_origin.global_position, skill.element, reaction)
		# don't change current element if skill has no element
		if (skill.element != "none"):
			current_element = skill.element
		if skill.double_hit == true:
			await get_tree().create_timer(0.3).timeout
			var r2 = await ReactionManager.reaction(current_element, skill.element2, self, skill.damage2, 1)
			if (r2):
				await reaction_ended 
			if (!r2):
				self.take_damage(skill.damage)
			DamageNumbers.display_number(skill.damage, damage_number_origin.global_position, skill.element, reaction)
			if (skill.element != "none"):
				current_element = skill.element
	#handle status effects
	if skill.status_effects != []:
		for x in skill.status_effects:
			status.append(x)
	hp_bar.update_element(current_element)
	
func reaction_signal():
	reaction_ended.emit()
	
func receive_skill_friendly(skill):
	var rounded : int
	var reaction = ""
	var number = skill.damage
	var r = await ReactionManager.reaction(current_element, skill.element, self, skill.damage, 0)
	if skill.shielding == true:
		self.receive_shielding(skill.damage)
	if skill.healing == true:
		if (health + number >= max_health):
			number = max_health - health
		self.receive_healing(skill.damage)
	DamageNumbers.display_number_plus(number, damage_number_origin.global_position, skill.element, reaction)
	if (skill.element != "none"):
		current_element = skill.element
	#handle status effects
	if skill.status_effects != []:
		for x in skill.status_effects:
			status.append(x)
	hp_bar.update_element(current_element)
	
	
	
func take_damage(damage : int):
	var damage_left = damage
	var total_dmg = damage
	if bubbled:
		damage_left = damage/2
		total_dmg = damage_left
		bubbled = false
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
	return total_dmg

func receive_healing(healing: int):
	health += healing
	if health >= max_health:
		health = max_health
	hp_bar.set_hp(health)
	
func receive_shielding(shielding: int):
	shield += shielding
	hp_bar.set_shield(shield)

func show_skills():
	spell_select_ui.visible = true
	
func hide_skills():
	spell_select_ui.visible = false
	
func set_shield(shield):
	self.shield = shield
	hp_bar.set_shield(shield)
	
func execute_status(status_effect):
	if (status_effect.unique_type == "bubble"):
		if status_effect.turns_remaining > 0:
			bubbled = true
	if (status_effect.damage > 0):
		take_damage(status_effect.damage)
		DamageNumbers.display_number(status_effect.damage, damage_number_origin.global_position, status_effect.element, "")
	status_effect.turns_remaining -= 1
	if status_effect.turns_remaining == 0:
		status.erase(status_effect)
		
func get_spell_select():
	return spell_select_ui
