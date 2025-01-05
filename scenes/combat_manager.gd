extends Node

@onready var turn_text: Label = $TurnText

@export var ally1 : Ally
@export var ally2 : Ally
@export var ally3 : Ally
@export var ally4 : Ally
@export var enemy1 : Enemy

@export var action_queue = []
@onready var end_turn: Button = $"../EndTurn"
@onready var reset_choices: Button = $"../ResetChoices"

var ally1skill : int
var ally2skill : int
var ally3skill : int
var ally4skill : int

var next_pos : int

var ally1_pos : int
var ally2_pos : int
var ally3_pos : int
var ally4_pos : int

var positions = [ally1_pos, ally2_pos, ally3_pos, ally4_pos]
signal ally_turn_done
signal enemy_turn_done
var combat_finished = false
var first_turn = true

signal hit
signal signal_received
signal reaction_finished
func _ready() -> void:
	# waiting for everything to load in
	await get_tree().create_timer(0.1).timeout
	ReactionManager.reaction_finished.connect(self.reaction_signal)
	reset_skill_select()
	# hiding skills at the start because start of all turn toggles skills already
	toggle_skills()
	start_combat()
	
func start_combat():
	while (!combat_finished):
		start_ally_turn()
		await ally_turn_done
		enemy_turn()
		await enemy_turn_done
	
func start_ally_turn():
	end_turn.visible = true
	reset_choices.visible = true
	turn_text.text = "Ally Turn"
	lose_shields()
	toggle_skills()
	reset_skill_select()
	update_skill_positions()

	
func execute_ally_turn():
	toggle_skills()
	end_turn.visible = false
	reset_choices.visible = false
	for x in action_queue:
		use_skill(x)
		print("waiting for reaction")
		await reaction_finished
		print(str(x.name) + " landed!")
		hit.emit()
		await get_tree().create_timer(0.5).timeout
	turn_text.text = "Enemy Turn"
	ally_turn_done.emit()

func enemy_turn():
	await get_tree().create_timer(1).timeout
	var skill = enemy1.current_skill
	ally1.receive_skill(skill.damage, skill.element)
	ally2.receive_skill(skill.damage, skill.element)
	ally3.receive_skill(skill.damage, skill.element)
	ally4.receive_skill(skill.damage, skill.element)
	hit.emit()
	enemy1.change_skills()
	await get_tree().create_timer(1).timeout
	enemy_turn_done.emit()
	
func use_skill(skill):
	if skill.friendly == false:
		enemy1.receive_skill(skill.damage, skill.element)
		print("waiting use skill")
		await reaction_finished
		print("finished waiting use skill")
	elif skill.friendly == true:
		ally1.receive_skill_friendly(skill.damage, skill.element)
		ally2.receive_skill_friendly(skill.damage, skill.element)
		ally3.receive_skill_friendly(skill.damage, skill.element)
		ally4.receive_skill_friendly(skill.damage, skill.element)

func reaction_signal():
	await get_tree().create_timer(0.01).timeout
	reaction_finished.emit()
	
func lose_shields():
	ally1.set_shield(0)
	ally2.set_shield(0)
	ally3.set_shield(0)
	ally4.set_shield(0)
	
# char 1
func _on_spell_select_ui_new_select() -> void:
	var spell_select_ui: Control = $"../Ally1/SpellSelectUi"
	var change = false
	# if selecting something when not already selected on that character
	if (spell_select_ui.selected != 0 and ally1skill == -1):
		ally1_pos = next_pos
		next_pos += 1
		spell_select_ui.update_pos(ally1_pos + 1)
	# if changing selection and not unselecting
	if (ally1skill != -1 and spell_select_ui.selected != 0):
		action_queue.remove_at(ally1_pos)
		change = true
	ally1skill = spell_select_ui.selected
	match spell_select_ui.selected:
		# if unselecting
		0:
			next_pos -= 1
			action_queue.remove_at(ally1_pos)
			update_positions(ally1_pos)
			spell_select_ui.update_pos(0)
			ally1_pos = -1
			update_skill_positions()
			ally1skill = -1
		1:
			if change:
				action_queue.insert(ally1_pos,ally1.basic_atk)
			else:
				action_queue.append(ally1.basic_atk)
		2:
			if change:
				action_queue.insert(ally1_pos,ally1.skill_1)
			else:
				action_queue.append(ally1.skill_1)
		3:
			if change:
				action_queue.insert(ally1_pos,ally1.skill_2)
			else:
				action_queue.append(ally1.skill_2)
		4:
			if change:
				action_queue.insert(ally1_pos,ally1.ult)
			else:
				action_queue.append(ally1.ult)
	print(action_queue)
		

# char 2
func _on_spell_select_ui_2_new_select() -> void:
	var spell_select_ui: Control = $"../Ally2/SpellSelectUi"
	var change = false
	if (spell_select_ui.selected != 0 and ally2skill == -1):
		ally2_pos = next_pos
		next_pos += 1
		spell_select_ui.update_pos(ally2_pos + 1)
	if (ally2skill != -1 and spell_select_ui.selected != 0):
		action_queue.remove_at(ally2_pos)
		change = true
	ally2skill = spell_select_ui.selected
	
	match spell_select_ui.selected:
		0:
			next_pos -= 1
			action_queue.remove_at(ally2_pos)
			update_positions(ally2_pos)
			spell_select_ui.update_pos(0)
			ally2_pos = -1
			update_skill_positions()
			ally2skill = -1
		1:
			if change:
				action_queue.insert(ally2_pos,ally2.basic_atk)
			else:
				action_queue.append(ally2.basic_atk)
		2:
			if change:
				action_queue.insert(ally2_pos,ally2.skill_1)
			else:
				action_queue.append(ally2.skill_1)
		3:
			if change:
				action_queue.insert(ally2_pos,ally2.skill_2)
			else:
				action_queue.append(ally2.skill_2)
		4:
			if change:
				action_queue.insert(ally2_pos,ally2.ult)
			else:
				action_queue.append(ally2.ult)
	print(action_queue)

# char 3
func _on_spell_select_ui_3_new_select() -> void:
	var spell_select_ui: Control = $"../Ally3/SpellSelectUi"
	var change = false
	if (spell_select_ui.selected != 0 and ally3skill == -1):
		ally3_pos = next_pos
		next_pos += 1
		spell_select_ui.update_pos(ally3_pos + 1)
	if (ally3skill != -1 and spell_select_ui.selected != 0):
		action_queue.remove_at(ally3_pos)
		change = true
	ally3skill = spell_select_ui.selected
	match spell_select_ui.selected:
		0:
			next_pos -= 1
			action_queue.remove_at(ally3_pos)
			update_positions(ally3_pos)
			spell_select_ui.update_pos(0)
			ally3_pos = -1
			update_skill_positions()
			ally3skill = -1
		1:
			if change:
				action_queue.insert(ally3_pos,ally3.basic_atk)
			else:
				action_queue.append(ally3.basic_atk)
		2:
			if change:
				action_queue.insert(ally3_pos,ally3.skill_1)
			else:
				action_queue.append(ally3.skill_1)
		3:
			if change:
				action_queue.insert(ally3_pos,ally3.skill_2)
			else:
				action_queue.append(ally3.skill_2)
		4:
			if change:
				action_queue.insert(ally3_pos,ally3.ult)
			else:
				action_queue.append(ally3.ult)
	print(action_queue)

# char 4
func _on_spell_select_ui_4_new_select() -> void:
	var spell_select_ui: Control = $"../Ally4/SpellSelectUi"
	var change = false
	if (spell_select_ui.selected != 0 and ally4skill == -1):
		ally4_pos = next_pos
		next_pos += 1
		spell_select_ui.update_pos(ally4_pos + 1)
	if (ally4skill != -1 and spell_select_ui.selected != 0):
		action_queue.remove_at(ally4_pos)
		change = true
	ally4skill = spell_select_ui.selected
	match spell_select_ui.selected:
		0:
			
			next_pos -= 1
			action_queue.remove_at(ally4_pos)
			update_positions(ally4_pos)
			spell_select_ui.update_pos(0)
			ally4_pos = -1
			update_skill_positions()
			ally4skill = -1
		1:
			if change:
				action_queue.insert(ally4_pos,ally4.basic_atk)
			else:
				action_queue.append(ally4.basic_atk)
		2:
			if change:
				action_queue.insert(ally4_pos,ally4.skill_1)
			else:
				action_queue.append(ally4.skill_1)
		3:
			if change:
				action_queue.insert(ally4_pos,ally4.skill_2)
			else:
				action_queue.append(ally4.skill_2)
		4:
			if change:
				action_queue.insert(ally4_pos,ally4.ult)
			else:
				action_queue.append(ally4.ult)
	print(action_queue)
	
func update_positions(cpos):
	if ally1_pos > cpos:
		ally1_pos -= 1
	if ally2_pos > cpos:
		ally2_pos -= 1
	if ally3_pos > cpos:
		ally3_pos -= 1
	if ally4_pos > cpos:
		ally4_pos -= 1

func update_skill_positions():
	var spell_select_ui1: Control = $"../Ally1/SpellSelectUi"
	var spell_select_ui2: Control = $"../Ally2/SpellSelectUi"
	var spell_select_ui3: Control = $"../Ally3/SpellSelectUi"
	var spell_select_ui4: Control = $"../Ally4/SpellSelectUi"
	
	spell_select_ui1.update_pos(ally1_pos + 1)
	spell_select_ui2.update_pos(ally2_pos + 1)
	spell_select_ui3.update_pos(ally3_pos + 1)
	spell_select_ui4.update_pos(ally4_pos + 1)

func reset_skill_select():
	var spell_select_ui1: Control = $"../Ally1/SpellSelectUi"
	var spell_select_ui2: Control = $"../Ally2/SpellSelectUi"
	var spell_select_ui3: Control = $"../Ally3/SpellSelectUi"
	var spell_select_ui4: Control = $"../Ally4/SpellSelectUi"
	action_queue = []
	next_pos = 0
	ally1_pos = -1
	ally2_pos = -1
	ally3_pos = -1
	ally4_pos = -1
	ally1skill = -1
	ally2skill = -1
	ally3skill = -1
	ally4skill = -1
	spell_select_ui1.reset()
	spell_select_ui2.reset()
	spell_select_ui3.reset()
	spell_select_ui4.reset()
	spell_select_ui1.update_pos(ally1_pos + 1)
	spell_select_ui2.update_pos(ally2_pos + 1)
	spell_select_ui3.update_pos(ally3_pos + 1)
	spell_select_ui4.update_pos(ally4_pos + 1)
	update_skill_positions()
	
func _on_end_turn_pressed() -> void:
	execute_ally_turn()

func _on_reset_choices_pressed() -> void:
	action_queue = []
	next_pos = 0
	ally1_pos = -1
	ally2_pos = -1
	ally3_pos = -1
	ally4_pos = -1
	reset_skill_select()
	update_skill_positions()
	
func toggle_skills():
	ally1.toggle_skills()
	ally2.toggle_skills()
	ally3.toggle_skills()
	ally4.toggle_skills()
