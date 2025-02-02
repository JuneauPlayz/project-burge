extends Unit
class_name Ally

@export var basic_atk : Skill
@export var skill_1: Skill
@export var skill_2: Skill
@export var ult: Skill

@export var ult_choice_1 : Skill
@export var ult_choice_2 : Skill

@export var relic_choice_1 : Relic
@export var relic_choice_2 : Relic
@export var relic_choice_3 : Relic
@export var relic_choice_4 : Relic

var skill_swap_1 : Skill
var skill_swap_1_spot : int
var skill_swap_2 : Skill

var ally_num : int

@onready var sprite_spot: Sprite2D = $SpriteSpot

@onready var spell_select_ui: Control = $SpellSelectUi
@onready var level_up_reward: Control = $LevelUpReward
@onready var swap_tutorial: Label = $LevelUpReward/SwapTutorial
@onready var confirm_swap: Button = $LevelUpReward/ConfirmSwap

var combat = true
var shop = false

var level_up_complete = false

var position = 0

var level
var level_up

var chosen_relic
signal loaded
# special status checks
var sow_just_applied = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# loading
	await get_tree().create_timer(0.1).timeout
	# spell select ui first child, hp bar ui second child
	if (combat):
		combat_manager = get_parent().get_parent().combat_manager
	hp_bar = $"HP Bar"
	targeting_area = $TargetingArea

	health = res.starting_health
	max_health = res.starting_health
	basic_atk = res.skill1
	skill_1 = res.skill2
	skill_2 = res.skill3
	ult = res.skill4
	ult_choice_1 = res.ult_1
	ult_choice_2 = res.ult_2
	relic_choice_1 = res.relic_1
	relic_choice_2 = res.relic_2
	relic_choice_3 = res.relic_3
	relic_choice_4 = res.relic_4
	level_up = res.level_up
	level = res.level
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
	relic_choice_1 = res.relic_1
	relic_choice_2 = res.relic_2
	relic_choice_3 = res.relic_3
	relic_choice_4 = res.relic_4
	level = res.level
	level_up = res.level_up
	title = res.name
	#sprite_spot.texture = load(res.sprite.resource_path)
	#sprite_spot.scale = Vector2(res.sprite_scale,res.sprite_scale)
	spell_select_ui.skill1 = basic_atk
	spell_select_ui.skill2 = skill_1
	spell_select_ui.skill3 = skill_2
	spell_select_ui.skill4 = ult

func show_skills():
	spell_select_ui.visible = true
	
func hide_skills():
	spell_select_ui.visible = false
	
	
func update_skills():
	spell_select_ui.load_skills()
	
func show_level_up(level):
	level_up_reward.visible = true
	match level:
		1:
			level_up_reward.load_options(relic_choice_1, relic_choice_2)
		2:
			level_up_reward.load_skills(ult_choice_1, ult_choice_2)
		3:
			level_up_reward.load_options(relic_choice_3, relic_choice_4)


func _on_spell_select_ui_new_select(ally) -> void:
	AudioPlayer.play_FX("click",-10)
	skill_swap_1_spot = spell_select_ui.selected
	if skill_swap_2 != null:
		confirm_swap.visible = true
	if shop:
		var shop = get_tree().get_first_node_in_group("shop")
		shop.new_skill_ally = self
		


func _on_level_up_reward_new_select(skill) -> void:
	if level_up_reward.choosing_skills:
		AudioPlayer.play_FX("click",-10)
		skill_swap_2 = skill
		swap_tutorial.visible = true
		if (skill_swap_1_spot > 0):
			confirm_swap.visible = true
	if level_up_reward.choosing_options:
		chosen_relic = skill
		confirm_swap.visible = true

func get_spell_select():
	return spell_select_ui


func _on_targeting_area_pressed() -> void:
	target_chosen.emit(self)


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
	update_ally_skills()
	swap_tutorial.visible = false
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


func _on_confirm_swap_level_pressed() -> void:
	AudioPlayer.play_FX("click",-10)
	if level_up_reward.choosing_skills:
		match skill_swap_1_spot:
			1:
				basic_atk = skill_swap_2
			2:
				skill_1 = skill_swap_2
			3:
				skill_2 = skill_swap_2
			4:
				ult = skill_swap_2
	if level_up_reward.choosing_options:
		var relic_handler = get_tree().get_first_node_in_group("relic_handler")
		GC.relics.append(chosen_relic)
		relic_handler.purchase_relic(chosen_relic)
	level_up_reward.visible = false
	level_up_reward.choosing_skills = false
	level_up_reward.choosing_options = false
	level_up = false
	res.level_up = false
	match skill_swap_1_spot:
		1:
			basic_atk = skill_swap_2
		2:
			skill_1 = skill_swap_2
		3:
			skill_2 = skill_swap_2
		4:
			ult = skill_swap_2
	update_ally_skills()
	swap_tutorial.visible = false
	level_up_complete = true
	spell_select_ui.reset()
