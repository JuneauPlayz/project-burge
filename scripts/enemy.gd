extends Unit
class_name Enemy

@export var skill1 : Skill
@export var skill2 : Skill
@export var skill3 : Skill
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


var BLEED = preload("res://resources/Status Effects/Bleed.tres")

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
	if res.skill1 != null:
		skill1 = res.skill1
		current_skill = skill1
	if res.skill2 != null:
		skill2 = res.skill2
	if res.skill3 != null:
		skill3 = res.skill3
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
	self.target_chosen.connect(combat_manager.target_signal)



func receive_skill(skill):
	var rounded : int
	var reaction = ""
	if (!connected):
		ReactionManager.reaction_finished.connect(self.reaction_signal)
		connected = true
	var r = await ReactionManager.reaction(current_element, skill.element, self, skill.final_damage, 1)
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
		self.take_damage(skill.final_damage)
		DamageNumbers.display_number(skill.final_damage, damage_number_origin.global_position, skill.element, reaction)
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
			if x.name == "Bleed":
				var new_bleed = BLEED.duplicate()
				status.append(new_bleed)
	hp_bar.update_element(current_element)

func receive_healing(healing: int):
	health += healing
	if health >= max_health:
		health = max_health
	hp_bar.set_hp(health)

func reaction_signal():
	reaction_ended.emit()
	
	

func take_damage(damage : int):
	if (self.visible == true):
		AudioPlayer.play_FX("fire_hit", -30)
		health -= damage
		hp_bar.set_hp(health)
		check_if_dead()
	return damage

func check_if_dead():
	if health <= 0:
		die()

func die():
	print("ded")
	died.emit()
	self.visible = false
	# wont erase itself until after the skill is done
	await get_tree().create_timer(GC.GLOBAL_INTERVAL).timeout
	combat_manager.enemies.erase(self)
	combat_manager.set_unit_pos()
	queue_free()
	
func change_skills():
	
	if current_skill == skill1:
		current_skill = skill2
	elif current_skill == skill2:
		current_skill = skill1
	skill_info.skill = current_skill
	skill_info.update_skill_info()
	
func enable_targeting_area():
	targeting_area.visible = true

func disable_targeting_area():
	targeting_area.visible = false

func _on_targeting_area_pressed() -> void:
	target_chosen.emit(self)
	
func execute_status(status_effect):
	print(status_effect)
	take_damage(status_effect.damage)
	DamageNumbers.display_number(status_effect.damage, damage_number_origin.global_position, status_effect.element, "")
	status_effect.turns_remaining -= 1
	
func random_skill():
	rng = RandomNumberGenerator.new()
	random_num = rng.randi_range(1,3)
	match random_num:
		1:
			return skill1
		2:
			return skill2
		3:
			return skill3
			
func hide_next_skill_info():
	show_next_skill.visible = false
	
func show_next_skill_info():
	show_next_skill.visible = true
	
