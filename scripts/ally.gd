extends Unit
class_name Ally

@export var basic_atk : Skill
@export var skill_1: Skill
@export var skill_2: Skill
@export var ult: Skill

@export var ult_choice_1 : Skill
@export var ult_choice_2 : Skill
@export var status : Array = []

var skill_swap_1 : Skill
var skill_swap_1_spot : int
var skill_swap_2 : Skill

var ally_num : int
var current_element = "none"

const BLEED = preload("res://resources/Status Effects/Bleed.tres")
const BUBBLE = preload("res://resources/Status Effects/Bubble.tres")
const BURN = preload("res://resources/Status Effects/Burn.tres")
const MUCK = preload("res://resources/Status Effects/Muck.tres")
const NITRO = preload("res://resources/Status Effects/Nitro.tres")
const SOW = preload("res://resources/Status Effects/Sow.tres")

@onready var sprite_spot: Sprite2D = $SpriteSpot

@onready var damage_number_origin: Node2D = $DamageNumberOrigin
@onready var spell_select_ui: Control = $SpellSelectUi
@onready var hp_bar: Control = $"HP Bar"
@onready var level_up_reward: Control = $LevelUpReward
@onready var swap_tutorial: Label = $LevelUpReward/SwapTutorial
@onready var confirm_swap: Button = $LevelUpReward/ConfirmSwap
@onready var targeting_area: Button = $TargetingArea

var combat = true
var shop = false

var level = 0
var level_up_complete = false

var position = 0
var combat_manager
var connected = false

var res : UnitRes

signal reaction_ended
signal target_chosen
signal loaded
# special status checks
var bubble = false
var muck = false
var nitro = false
var sow = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# loading
	await get_tree().create_timer(0.1).timeout
	# spell select ui first child, hp bar ui second child
	if (combat):
		combat_manager = get_parent().get_parent().combat_manager
	health = res.starting_health
	max_health = res.starting_health
	basic_atk = res.skill1
	skill_1 = res.skill2
	skill_2 = res.skill3
	ult = res.skill4
	ult_choice_1 = res.ult_1
	ult_choice_2 = res.ult_2
	sprite_spot.texture = load(res.sprite.resource_path)
	sprite_spot.scale = Vector2(res.sprite_scale,res.sprite_scale)
	spell_select_ui.skill1 = basic_atk
	spell_select_ui.skill2 = skill_1
	spell_select_ui.skill3 = skill_2
	spell_select_ui.skill4 = ult
	spell_select_ui.load_skills()
	if combat:
		spell_select_ui.new_select.connect(combat_manager._on_spell_select_ui_new_select)
	hp_bar.set_hp(max_health)
	hp_bar.set_maxhp(max_health)
	if combat:
		self.target_chosen.connect(combat_manager.target_signal)
		hp_bar.update_statuses(status)
	
func update_vars():
	basic_atk = res.skill1
	skill_1 = res.skill2
	skill_2 = res.skill3
	ult = res.skill4
	ult_choice_1 = res.ult_1
	ult_choice_2 = res.ult_2
	title = res.name
	sprite_spot.texture = load(res.sprite.resource_path)
	sprite_spot.scale = Vector2(res.sprite_scale,res.sprite_scale)
	spell_select_ui.skill1 = basic_atk
	spell_select_ui.skill2 = skill_1
	spell_select_ui.skill3 = skill_2
	spell_select_ui.skill4 = ult

func receive_skill(skill, unit, value_multiplier):
	var rounded : int
	var reaction = ""
	var value = skill.final_damage * value_multiplier
	var value2 = skill.damage2 * value_multiplier
	if (!connected):
		ReactionManager.reaction_finished.connect(self.reaction_signal)
		connected = true
	var r = await ReactionManager.reaction(current_element, skill.element, self, value, skill.friendly)
	if (r): 
		await reaction_ended 
		if skill.double_hit == true:
			await get_tree().create_timer(0.3).timeout
			var r2 = await ReactionManager.reaction(current_element, skill.element2, self, value2, skill.friendly)
			if (r2):
				await reaction_ended 
				DamageNumbers.display_number(self.take_damage(value2), damage_number_origin.global_position, skill.element2, reaction)
			if (!r2):
				DamageNumbers.display_number(self.take_damage(value2), damage_number_origin.global_position, skill.element2, reaction)
			if (skill.element != "none"):
				current_element = skill.element
	# no reaction
	if (!r):
		DamageNumbers.display_number(self.take_damage(value), damage_number_origin.global_position, skill.element, reaction)
		# don't change current element if skill has no element
		if (skill.element != "none"):
			current_element = skill.element
		if skill.double_hit == true:
			await get_tree().create_timer(0.3).timeout
			var r2 = await ReactionManager.reaction(current_element, skill.element2, self, value2, skill.friendly)
			if (r2):
				await reaction_ended 
			if (!r2):
				DamageNumbers.display_number(self.take_damage(value2), damage_number_origin.global_position, skill.element2, reaction)
			if (skill.element != "none"):
				current_element = skill.element
	#handle status effects
	if skill.status_effects != []:
		for x in skill.status_effects:
			if x.name == "Bleed":
				var new_bleed = BLEED.duplicate()
				status.append(new_bleed)
			if x.name == "Burn":
				var new_burn = BURN.duplicate()
				status.append(new_burn)
			if x.name == "Bubble":
				var new_bubble = BUBBLE.duplicate()
				status.append(new_bubble)
			if x.name == "Muck":
				var new_muck = MUCK.duplicate()
				status.append(new_muck)
			if x.name == "Nitro":
				var new_nitro = NITRO.duplicate()
				status.append(new_nitro)
		hp_bar.update_statuses(status)
	if sow:
		unit.receive_healing(roundi(GC.sow_healing * GC.sow_healing_mult))
		unit.receive_shielding(roundi(GC.sow_shielding * GC.sow_shielding_mult))
		DamageNumbers.display_number_plus(roundi(GC.sow_healing * GC.sow_healing_mult), unit.damage_number_origin.global_position, "grass", "")
		DamageNumbers.display_number_plus(roundi(GC.sow_shielding * GC.sow_shielding_mult), unit.damage_number_origin.global_position, "earth", "")
		sow = false
		for stati in status:
			if stati.name == "Sow":
				status.erase(stati)
				hp_bar.update_statuses(status)
				DamageNumbers.display_text(self.damage_number_origin.global_position, "none", "Harvest!", 32)
	hp_bar.update_element(current_element)
	
func reaction_signal():
	reaction_ended.emit()
	
func receive_skill_friendly(skill, unit, value_multiplier):
	print("receiving friendly skill")
	var rounded : int
	var reaction = ""
	var number = skill.damage * value_multiplier
	var value = skill.damage * value_multiplier
	var r = await ReactionManager.reaction(current_element, skill.element, self, value, skill.friendly)
	if skill.shielding == true:
		self.receive_shielding(value)
	if skill.healing == true:
		if (health + number >= max_health):
			number = max_health - health
		self.receive_healing(value)
	DamageNumbers.display_number_plus(number, damage_number_origin.global_position, skill.element, reaction)
	if (skill.element == "none"):
		current_element = skill.element
	#handle status effects
	if skill.status_effects != []:
		for x in skill.status_effects:
			status.append(x)
	hp_bar.update_element(current_element)
	hp_bar.update_statuses(status)
	
	
	
func take_damage(damage : int):
	AudioPlayer.play_FX("fire_hit", -30)
	var damage_left = roundi(damage)
	var total_dmg = roundi(damage)
	if bubble:
		damage_left = roundi(damage * GC.bubble_mult)
		total_dmg = damage_left
		bubble = false
		DamageNumbers.display_text(self.damage_number_origin.global_position, "none", "Pop!", 32)
		for stati in status:
			if stati.name == "Bubble":
				status.erase(stati)
				hp_bar.update_statuses(status)
				self.receive_healing(GC.ally_bloom_healing * GC.bloom_mult)
				DamageNumbers.display_number_plus(GC.ally_bloom_healing * GC.bloom_mult, damage_number_origin.global_position, "grass", "")
	if nitro:
		nitro = false
		for stati in status:
			if stati.name == "Nitro":
				status.erase(stati)
				hp_bar.update_statuses(status)
				damage_left = damage_left * GC.nitro_mult
				DamageNumbers.display_text(self.damage_number_origin.global_position, "none", "Nitrate!", 32)
		total_dmg = damage_left
	if (shield > 0):
		if (shield <= damage_left):
			damage_left -= shield
			shield = 0
		elif (shield > damage_left):
			shield -= damage_left
			damage_left = 0
		hp_bar.set_shield(shield)
	health -= damage_left
	check_if_dead()
	hp_bar.set_hp(health)
	return total_dmg

func receive_healing(healing: int):
	health += healing
	if health >= max_health:
		health = max_health
	hp_bar.set_hp(health)
	return healing
	
func receive_shielding(shielding: int):
	shield += shielding
	hp_bar.set_shield(shield)
	return shielding

func check_if_dead():
	if health <= 0:
		die()

func die():
	print(title + " ded")
	self.visible = false
	await get_tree().create_timer(GC.GLOBAL_INTERVAL).timeout
	# wont erase itself until after the skill is done
	combat_manager.allies.erase(self)
	combat_manager.set_unit_pos()
	queue_free()

func show_skills():
	spell_select_ui.visible = true
	
func hide_skills():
	spell_select_ui.visible = false
	
func set_shield(shield):
	self.shield = shield
	hp_bar.set_shield(shield)
	
func execute_status(status_effect):
	if status_effect.event_based == false:
		take_damage(status_effect.damage)
		DamageNumbers.display_number(status_effect.damage, damage_number_origin.global_position, status_effect.element, "")
		status_effect.turns_remaining -= 1
	else:
		if status_effect.name == "Bubble":
			bubble = true
		elif status_effect.name == "Muck":
			muck = true
		elif status_effect.name == "Nitro":
			nitro = true
		elif status_effect.name == "Sow":
			sow = true
	hp_bar.update_statuses(status)
		
func get_spell_select():
	return spell_select_ui

func update_skills():
	spell_select_ui.load_skills()
	
func show_level_up(level):
	level_up_reward.visible = true
	match level:
		1:
			level_up_reward.load_skills(ult_choice_1, ult_choice_2)
			


func _on_spell_select_ui_new_select(ally) -> void:
	AudioPlayer.play_FX("click",-10)
	skill_swap_1_spot = spell_select_ui.selected
	if skill_swap_2 != null:
		confirm_swap.visible = true
	if shop:
		var shop = get_tree().get_first_node_in_group("shop")
		shop.new_skill_ally = self
		


func _on_level_up_reward_new_select(skill) -> void:
	AudioPlayer.play_FX("click",-10)
	skill_swap_2 = skill
	swap_tutorial.visible = true
	if (skill_swap_1_spot > 0):
		confirm_swap.visible = true


func _on_confirm_swap_pressed() -> void:
	AudioPlayer.play_FX("click",-10)
	match skill_swap_1_spot:
		1:
			basic_atk = skill_swap_2
		2:
			skill_1 = skill_swap_2
		3:
			skill_2 = skill_swap_2
		4:
			ult = skill_swap_2
	level_up_reward.visible = false
	update_ally_skills()
	swap_tutorial.visible = false
	level_up_complete = true
	spell_select_ui.reset()
	
func update_ally_skills():
	spell_select_ui.skill1 = basic_atk
	spell_select_ui.skill2 = skill_1
	spell_select_ui.skill3 = skill_2
	spell_select_ui.skill4 = ult
	spell_select_ui.load_skills()
	match ally_num:
		1:
			GC.ally1.skill1 = basic_atk
			GC.ally1.skill2 = skill_1
			GC.ally1.skill3 = skill_2
			GC.ally1.skill4 = ult
		2:
			GC.ally2.skill1 = basic_atk
			GC.ally2.skill2 = skill_1
			GC.ally2.skill3 = skill_2
			GC.ally2.skill4 = ult
		3:
			GC.ally3.skill1 = basic_atk
			GC.ally3.skill2 = skill_1
			GC.ally3.skill3 = skill_2
			GC.ally3.skill4 = ult
		4:
			GC.ally4.skill1 = basic_atk
			GC.ally4.skill2 = skill_1
			GC.ally4.skill3 = skill_2
			GC.ally4.skill4 = ult
	pass
	
func enable_targeting_area():
	targeting_area.visible = true

func disable_targeting_area():
	targeting_area.visible = false

func _on_targeting_area_pressed() -> void:
	target_chosen.emit(self)
