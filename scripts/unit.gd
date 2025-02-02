extends Node
class_name Unit

# Common Variables
@export var health = 0
@export var max_health = 0
@export var shield = 0
@export var status : Array = []
var current_element : String = "none"
var bubble : bool = false
var muck : bool = false
var nitro : bool = false
var sow : bool = false
var res : UnitRes
var connected = false
var left : Unit
var right : Unit

@export var defense : float
@export var status_resistance: float
@export var title : String

# Status Effect Constants
const BLEED = preload("res://resources/Status Effects/Bleed.tres")
const BUBBLE = preload("res://resources/Status Effects/Bubble.tres")
const BURN = preload("res://resources/Status Effects/Burn.tres")
const MUCK = preload("res://resources/Status Effects/Muck.tres")
const NITRO = preload("res://resources/Status Effects/Nitro.tres")
const SOW = preload("res://resources/Status Effects/Sow.tres")

# Nodes
@onready var damage_number_origin: Node2D = $DamageNumberOrigin
var hp_bar
var combat_manager
var targeting_area


# Signals
signal reaction_ended
signal target_chosen
signal died
# Common Methods

func receive_skill(skill, unit, value_multiplier):
	var rounded : int
	var reaction = ""
	var value = skill.final_damage * value_multiplier
	var value2 = skill.damage2 * value_multiplier
	if (!connected):
		ReactionManager.reaction_finished.connect(self.reaction_signal)
		connected = true
	var r = await ReactionManager.reaction(current_element, skill.element, self, value, skill.friendly, unit)
	if (r): 
		await reaction_ended 
		if skill.double_hit == true:
			await get_tree().create_timer(0.3).timeout
			var r2 = await ReactionManager.reaction(current_element, skill.element2, self, value2, skill.friendly, unit)
			if (r2):
				await reaction_ended 
			if (!r2):
				self.take_damage(value2, skill.element2, true)
	if (!r):
		self.take_damage(value, skill.element, true)
		if (skill.element != "none"):
			current_element = skill.element
		if skill.double_hit == true:
			await get_tree().create_timer(0.3).timeout
			var r2 = await ReactionManager.reaction(current_element, skill.element2, self, value2, skill.friendly, unit)
			if (r2):
				await reaction_ended 
			if (!r2):
				self.take_damage(value2, skill.element2, true)
			if (skill.element != "none"):
				current_element = skill.element
	if skill.status_effects != []:
		for x in skill.status_effects:
			if x.name == "Bleed":
				var new_bleed = BLEED.duplicate()
				status.append(new_bleed)
			if x.name == "Burn":
				for stati in status:
					if stati.name == "Burn":
						status.erase(stati)
				hp_bar.update_statuses(status)
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
		unit.receive_healing(roundi(GC.sow_healing * GC.sow_healing_mult), "grass", false)
		unit.receive_shielding(roundi(GC.sow_shielding * GC.sow_shielding_mult), "earth", false)
		sow = false
		for stati in status:
			if stati.name == "Sow":
				status.erase(stati)
				hp_bar.update_statuses(status)
				DamageNumbers.display_text(self.damage_number_origin.global_position, "none", "Harvest!", 32)
	hp_bar.update_element(current_element)

func receive_skill_friendly(skill, unit, value_multiplier):
	var rounded : int
	var reaction = ""
	var number = skill.damage * value_multiplier
	var value = skill.damage * value_multiplier
	var r = await ReactionManager.reaction(current_element, skill.element, self, value, skill.friendly, unit)
	if (!r):
		if skill.shielding == true:
			self.receive_shielding(value, skill.element, false)
		if skill.healing == true:
			if (health + number >= max_health):
				number = max_health - health
			self.receive_healing(value, skill.element, false)
	DamageNumbers.display_number_plus(number, damage_number_origin.global_position, skill.element, reaction)
	if (skill.element == "none"):
		current_element = skill.element
	if skill.status_effects != []:
		for x in skill.status_effects:
			status.append(x)
	hp_bar.update_element(current_element)
	hp_bar.update_statuses(status)

func take_damage(damage : int, element : String, change_element : bool):
	AudioPlayer.play_FX("fire_hit", -30)
	if change_element:
		current_element = element
	hp_bar.update_element(current_element)
	var damage_left = roundi(damage)
	match element:
		"fire":
			damage_left += GC.fire_damage_bonus
			damage_left *= GC.fire_damage_mult
		"water":
			damage_left += GC.water_damage_bonus
			damage_left *= GC.water_damage_mult
		"lightning":
			damage_left += GC.lightning_damage_bonus
			damage_left *= GC.lightning_damage_mult
		"grass":
			damage_left += GC.grass_damage_bonus
			damage_left *= GC.grass_damage_mult
		"earth":
			damage_left += GC.earth_damage_bonus
			damage_left *= GC.earth_damage_mult
	var total_dmg = damage_left
	if bubble:
		damage_left = roundi(damage * GC.bubble_mult)
		total_dmg = damage_left
		bubble = false
		DamageNumbers.display_text(self.damage_number_origin.global_position, "none", "Pop!", 32)
		for stati in status:
			if stati.name == "Bubble":
				status.erase(stati)
				hp_bar.update_statuses(status)
				self.receive_healing(GC.ally_bloom_healing * GC.bloom_mult, "grass", false)
	if nitro:
		nitro = false
		for stati in status:
			if stati.name == "Nitro":
				status.erase(stati)
				hp_bar.update_statuses(status)
				damage_left = roundi(damage_left * GC.nitro_mult)
				DamageNumbers.display_text(self.damage_number_origin.global_position, "none", "Nitrate!", 32)
	DamageNumbers.display_number(damage_left, damage_number_origin.global_position, element, "")
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

func receive_healing(healing: int, element : String, change_element : bool):
	DamageNumbers.display_number_plus(healing, damage_number_origin.global_position, element, "")
	health += healing
	if health >= max_health:
		health = max_health
	hp_bar.set_hp(health)
	return healing

func receive_shielding(shielding: int, element : String, change_element : bool):
	DamageNumbers.display_number_plus(shielding, damage_number_origin.global_position, element, "")
	if change_element:
		shield += shielding
	hp_bar.set_shield(shield)
	return shielding

func check_if_dead():
	if health <= 0:
		die()

func die():
	print("ded")
	died.emit()
	self.visible = false
	combat_manager.enemies.erase(self)
	combat_manager.set_unit_pos()
	await get_tree().create_timer(GC.GLOBAL_INTERVAL).timeout

func hasLeft():
	return left != null

func hasRight():
	return right != null

func enable_targeting_area():
	targeting_area.visible = true

func disable_targeting_area():
	targeting_area.visible = false
	
func reaction_signal():
	reaction_ended.emit()

func execute_status(status_effect):
	if status_effect.event_based == false:
		take_damage(status_effect.damage, status_effect.element, true)
		status_effect.turns_remaining -= 1
		hp_bar.update_statuses(status)
	else:
		if status_effect.name == "Bubble":
			bubble = true
		elif status_effect.name == "Muck":
			muck = true
		elif status_effect.name == "Nitro":
			nitro = true
		elif status_effect.name == "Sow":
			sow = true
		
func set_shield(shield):
	self.shield = shield
	hp_bar.set_shield(shield)
