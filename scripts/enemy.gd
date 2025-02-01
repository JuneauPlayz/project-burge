extends Unit
class_name Enemy

@export var skill1 : Skill
@export var skill2 : Skill
@export var skill3 : Skill
@export var skill4 : Skill
var current_skill : Skill

@export var current_element : String = "none"
@export var reaction_primed = 0

@export var status : Array = []

@onready var damage_number_origin: Node2D = $DamageNumberOrigin
var hp_bar
@onready var skill_info: Control = $ShowNextSkill/SkillInfo
var connected = false
@onready var targeting_area: Button = $TargetingArea
var combat_manager: Node
var rng
var random_num
var res : UnitRes
@onready var sprite_spot: Sprite2D = $SpriteSpot
@onready var show_next_skill: Control = $ShowNextSkill

var bubble = false
var muck = false
var nitro = false
var sow = false

const BLEED = preload("res://resources/Status Effects/Bleed.tres")
const BUBBLE = preload("res://resources/Status Effects/Bubble.tres")
const BURN = preload("res://resources/Status Effects/Burn.tres")
const MUCK = preload("res://resources/Status Effects/Muck.tres")
const NITRO = preload("res://resources/Status Effects/Nitro.tres")
const SOW = preload("res://resources/Status Effects/Sow.tres")

signal skill_end
signal reaction_ended
signal target_chosen
signal died

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#always mak	e hp bar second child
	await get_tree().create_timer(0.1).timeout
	combat_manager = get_parent().get_parent().get_combat_manager()
	self.died.connect(combat_manager.reaction_signal)
	health = res.starting_health
	max_health = res.starting_health
	if res.skill1 != null:
		skill1 = res.skill1
		current_skill = skill1
	if res.skill2 != null:
		skill2 = res.skill2
	if res.skill3 != null:
		skill3 = res.skill3
	if res.skill4 != null:
		skill4 = res.skill4
	if res.name != null:
		title = res.name
	print("title:" + title)
	sprite_spot.texture = load(res.sprite.resource_path)
	sprite_spot.scale = Vector2(res.sprite_scale,res.sprite_scale)
	skill_info.skill = current_skill
	skill_info.update_skill_info()
	
	print(health)
	hp_bar = get_child(1)
	hp_bar.set_hp(health)
	hp_bar.set_maxhp(health)
	hp_bar.update_statuses(status)
	self.target_chosen.connect(combat_manager.target_signal)



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
		print("waiting for reaction")
		await reaction_ended 
		print("reaction received")
		if skill.double_hit == true:
			await get_tree().create_timer(0.3).timeout
			var r2 = await ReactionManager.reaction(current_element, skill.element2, self, value2, skill.friendly, unit)
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
			var r2 = await ReactionManager.reaction(current_element, skill.element2, self, value2, skill.friendly, unit)
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
	print("attempting to sow")
	if sow:
		print("sowing" + skill.name)
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


func receive_skill_friendly(skill, unit, value_multiplier):
	var rounded : int
	var reaction = ""
	var number = skill.damage * value_multiplier
	var value = skill.damage * value_multiplier
	var r = await ReactionManager.reaction(current_element, skill.element, self, value, skill.friendly, unit)
	if (!r):
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

func reaction_signal():
	reaction_ended.emit()
	
	

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

func lose_shield():
	shield = 0
func check_if_dead():
	if health <= 0:
		die()

func die():
	print("ded")
	died.emit()
	self.visible = false
	# wont erase itself until after the skill is done
	combat_manager.enemies.erase(self)
	combat_manager.set_unit_pos()
	await get_tree().create_timer(GC.GLOBAL_INTERVAL).timeout
	queue_free()
	
	
func enable_targeting_area():
	targeting_area.visible = true

func disable_targeting_area():
	targeting_area.visible = false

func _on_targeting_area_pressed() -> void:
	target_chosen.emit(self)
	
func execute_status(status_effect):
	if status_effect.event_based == false:
		take_damage(status_effect.damage)
		DamageNumbers.display_number(status_effect.damage, damage_number_origin.global_position, status_effect.element, "")
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
	
func change_skills():
	rng = RandomNumberGenerator.new()
	random_num = 1
	if skill2 != null:
		random_num = rng.randi_range(1,2)
	if skill3 != null:
		random_num = rng.randi_range(1,3)
	if skill4 != null:
		random_num = rng.randi_range(1,4)
	match random_num:
		1:
			current_skill = skill1
		2:
			current_skill = skill2
		3:
			current_skill = skill3
		4:
			current_skill = skill4
	skill_info.skill = current_skill
	skill_info.update_skill_info()
func hide_next_skill_info():
	show_next_skill.visible = false
	
func show_next_skill_info():
	show_next_skill.visible = true
	
