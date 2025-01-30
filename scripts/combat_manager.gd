extends Node

@onready var turn_text: Label = $TurnText
@onready var combat_currency: Control = $CombatCurrency

@export var ally1 : Ally
@export var ally2 : Ally
@export var ally3 : Ally
@export var ally4 : Ally
@export var allies : Array = []
var front_ally : Ally
var back_ally : Ally

@export var enemy1 : Enemy
@export var enemy2 : Enemy
@export var enemy3 : Enemy
@export var enemy4 : Enemy
@export var enemies : Array = []
var front_enemy : Enemy
var back_enemy : Enemy

var ally_list = [ally1, ally2, ally3, ally4]
var enemy_list = [enemy1, enemy2]

@export var action_queue = []
var choosing_skills = false
# parallel array for targets
@export var target_queue = []
var targeting = false

var targeting_skill : Skill
# parallel array for allies
@export var ally_queue = []

@onready var end_turn: Button = $"../EndTurn"
@onready var reset_choices: Button = $"../ResetChoices"
@onready var targeting_label: Label = $TargetingLabel
@onready var targeting_skill_info: Control = $TargetingSkillInfo
@onready var relics : RelicHandler
@onready var victory_screen: Control = $"../VictoryScreen"

var ally1skill : int
var ally2skill : int
var ally3skill : int
var ally4skill : int

var next_pos : int

var ally1_pos : int
var ally2_pos : int
var ally3_pos : int
var ally4_pos : int

const TARGET_CURSOR = preload("res://assets/target cursor.png")
const DEFAULT_CURSOR = preload("res://assets/defaultcursor.png")


signal ally_turn_done
signal enemy_turn_done
signal new_spell_selected
signal target_selected
signal target_chosen

var combat_finished = false
var first_turn = true
var victorious = false

signal hit


signal signal_received
signal reaction_finished

func combat_ready():
	# waiting for everything to load in
	
	await get_tree().create_timer(0.1).timeout
	reset_combat()
	if (enemy1 != null):
		enemies.append(enemy1)
	if (enemy2 != null):
		enemies.append(enemy2)
	if (enemy3 != null):
		enemies.append(enemy3)
	if (enemy4 != null):
		enemies.append(enemy4)
	if (ally1 != null):
		allies.append(ally1)
	if (ally2 != null):
		allies.append(ally2)
	if (ally3 != null):
		allies.append(ally3)
	if (ally4 != null):
		allies.append(ally4)
	for i in range(len(allies)):
		allies[i].position = i+1
	# setting left and right for units
	set_unit_pos()
	ReactionManager.reaction_finished.connect(self.reaction_signal)
	# relic stuff
	relics.relics_activated.connect(_on_relics_activated)
	relics.activate_relics_by_type(Relic.Type.START_OF_COMBAT)


func start_combat():
	show_skills()
	reset_skill_select()
	while (!combat_finished):
		start_ally_turn()
		await ally_turn_done
		enemy_turn()
		await enemy_turn_done

func end_battle():
	pass
	
func start_ally_turn():
	set_unit_pos()
	show_ui()
	check_requirements()
	turn_text.text = "Ally Turn"
	ally_pre_status()
	lose_shields()
	show_skills()
	reset_skill_select()
	update_skill_positions()
	choosing_skills = true

	
func execute_ally_turn():
	# skill execution
	for n in range(action_queue.size()):
		if (action_queue.size() == 0):
			continue
		var skill = action_queue[n]
		var target = target_queue[n]
		var ally = ally_queue[n]
		use_skill(skill,target,ally)
		print("waiting for reaction")
		# checks if target is dead, currently skips the rest of the loop (wont print landed)
		if (target == null or target.visible == false):
			await get_tree().create_timer(0.1).timeout
			continue
		await reaction_finished
		print(str(skill.name) + " landed!")
		hit.emit()
		await get_tree().create_timer(GC.GLOBAL_INTERVAL+0.05).timeout
	await get_tree().create_timer(1).timeout
	ally_post_status()
	if enemies.is_empty():
		victory()
	else:
		turn_text.text = "Enemy Turn"
		ally_turn_done.emit()

func enemy_turn():
	await get_tree().create_timer(0.25).timeout
	enemy_pre_status()
	await get_tree().create_timer(0.3).timeout
	for enemy in enemies:
		use_skill(enemy.current_skill,null,enemy)
		hit.emit()
		enemy.change_skills()
		await get_tree().create_timer(GC.GLOBAL_INTERVAL+0.05).timeout
	await get_tree().create_timer(0.1).timeout
	enemy_post_status()
	await get_tree().create_timer(0.3).timeout
	if allies.is_empty():
		defeat()
	else:
		enemy_turn_done.emit()


func victory():
	victorious = true
	victory_screen.visible = true
	victory_screen.update_text("Victory!", 10)
	GC.add_gold(10)
	hide_skills()
	hide_ui()
	victory_screen.continue_pressed.connect(self.finish_battle)

func defeat():
	victorious = false
	victory_screen.visible = true
	victory_screen.update_text("Defeat!", 0)
	GC.add_gold(0)
	hide_skills()
	hide_ui()
	for enemy in enemies:
		enemy.visible = false
	GC.reset()
	victory_screen.continue_pressed.connect(self.finish_battle)
	
func finish_battle():
	if victorious:
		get_tree().change_scene_to_file("res://scenes/main scenes/shop.tscn")
	if not victorious:
		get_tree().change_scene_to_file("res://scenes/main scenes/main_scene.tscn")

func reset_combat():
	allies = []
	enemies = []
	GC.reset_tokens()
	victory_screen.visible = false
	
func use_skill(skill,target,unit):
	skill.update()
	# token spending
	if skill.cost > 0 or skill.cost2 > 0:
			spend_skill_cost(skill)
	if (skill.target_type == "front_ally"):
		front_ally.receive_skill(skill)
	elif (skill.target_type == "front_enemy"):
		front_enemy.receive_skill(skill)
	elif (skill.target_type == "back_ally"):
		back_ally.receive_skill(skill)
	elif (skill.target_type == "back_enemy"):
		back_enemy.receive_skill(skill)
	elif (skill.target_type == "single_ally" and skill.friendly):
		target.receive_skill_friendly(skill)
	elif (target == null):
		if (skill.target_type == "all_allies"):
			if (skill.friendly == true):
				for ally in allies:
					ally.receive_skill_friendly(skill)
			else:
				for ally in allies:
					ally.receive_skill(skill)
					#print(ally.title + " taking " + str(skill.damage) + " damage from " + unit.title)
		if (skill.target_type == "all_enemies"):
			if (skill.friendly == true):
				for enemy in enemies:
					enemy.receive_skill_friendly(skill)
			else:
				for enemy in enemies:
					enemy.receive_skill(skill)
		if (skill.target_type == "all_units"):
			if (skill.friendly == true):
				for enemy in enemies:
					enemy.receive_skill_friendly(skill)
				for ally in allies:
					ally.receive_skill_friendly(skill)
			else:
				for enemy in enemies:
					enemy.receive_skill(skill)
				for ally in allies:
					ally.receive_skill(skill)
	else:
		if skill.damaging == true:
			target.receive_skill(skill)
			print("waiting use skill")
			await reaction_finished
			print("finished waiting use skill")
	if (skill.lifesteal):
		unit.receive_healing(roundi(skill.damage * skill.lifesteal_rate))

func spend_skill_cost(skill):
	var tokens1 = 0
	var tokens2 = 0
	print("spending tokens")
	if skill.cost > 0:
		match skill.token_type:
			"fire":
				GC.fire_tokens -= skill.cost
			"water":
				GC.water_tokens -= skill.cost
			"lightning":
				GC.lightning_tokens -= skill.cost
			"grass":
				GC.grass_tokens -= skill.cost
			"earth":
				GC.earth_tokens -= skill.cost
	if skill.cost2 > 0:
		match skill.token_type2:
			"fire":
				GC.fire_tokens -= skill.cost2
			"water":
				GC.water_tokens -= skill.cost2
			"lightning":
				GC.lightning_tokens -= skill.cost2
			"grass":
				GC.grass_tokens -= skill.cost2
			"earth":
				GC.earth_tokens -= skill.cost2
	combat_currency.update()

func _on_relics_activated(type : Relic.Type) -> void:
	match type:
		Relic.Type.START_OF_COMBAT:
			start_combat()
		Relic.Type.END_OF_COMBAT:
			end_battle()
		Relic.Type.END_OF_TURN:
			execute_ally_turn()
		
			
func reaction_signal():
	await get_tree().create_timer(0.01).timeout
	# update currency ui
	combat_currency.update()
	reaction_finished.emit()
	
func lose_shields():
	for ally in allies:
		ally.set_shield(0)
	
# char 1
func _on_spell_select_ui_new_select(ally) -> void:
	var spell_select_ui: Control = ally.get_spell_select()
	var change = false
	var ally_pos = 0
	var allyskill = 0
	match ally.position:
		1:
			allyskill = ally1skill
			ally_pos = ally1_pos
		2:
			allyskill = ally2skill
			ally_pos = ally2_pos
		3:
			allyskill = ally3skill
			ally_pos = ally3_pos
		4:
			allyskill = ally4skill
			ally_pos = ally4_pos

	# if selecting something when not already selected on that character
	if (spell_select_ui.selected != 0 and allyskill == -1):
		ally_pos = next_pos
		next_pos += 1
		spell_select_ui.update_pos(ally_pos + 1)
	# if changing selection and not unselecting
	if (allyskill != -1 and spell_select_ui.selected != 0):
		action_queue.remove_at(ally_pos)
		target_queue.remove_at(ally_pos)
		ally_queue.remove_at(ally_pos)
		spell_select_ui.update_pos(0)
		change = true
	allyskill = spell_select_ui.selected
	match spell_select_ui.selected:
		# if unselecting
		0:
			next_pos -= 1
			action_queue.remove_at(ally_pos)
			target_queue.remove_at(ally_pos)
			ally_queue.remove_at(ally_pos)
			update_positions(ally_pos)
			ally_pos = -1
			update_skill_positions()
			spell_select_ui.update_pos(0)
			allyskill = -1
		1:
			if change:
				action_queue.insert(ally_pos,ally.basic_atk)
				target_queue.insert(ally_pos,await choose_target(ally.basic_atk))
				ally_queue.insert(ally_pos,ally)
			else:
				action_queue.append(ally.basic_atk)
				target_queue.append(await choose_target(ally.basic_atk))
				ally_queue.append(ally)
		2:
			if change:
				action_queue.insert(ally_pos,ally.skill_1)
				target_queue.insert(ally_pos,await choose_target(ally.skill_1))
				ally_queue.insert(ally_pos,ally)
			else:
				action_queue.append(ally.skill_1)
				target_queue.append(await choose_target(ally.skill_1))
				ally_queue.append(ally)
		3:
			if change:
				action_queue.insert(ally_pos,ally.skill_2)
				target_queue.insert(ally_pos,await choose_target(ally.skill_2))
				ally_queue.insert(ally_pos,ally)
			else:
				action_queue.append(ally.skill_2)
				target_queue.append(await choose_target(ally.skill_2))
				ally_queue.append(ally)
		4:
			if change:
				action_queue.insert(ally_pos,ally.ult)
				target_queue.insert(ally_pos,await choose_target(ally.ult))
				ally_queue.insert(ally_pos,ally)
			else:
				action_queue.append(ally.ult)
				target_queue.append(await choose_target(ally.ult))
				ally_queue.append(ally)
	
	match ally.position:
		1:
			ally1skill = allyskill
			ally1_pos = ally_pos
			spell_select_ui.update_pos(ally1_pos+1)
		2:
			ally2skill = allyskill
			ally2_pos = ally_pos
			spell_select_ui.update_pos(ally2_pos+1)
		3:
			ally3skill = allyskill
			ally3_pos = ally_pos
			spell_select_ui.update_pos(ally3_pos+1)
		4:
			ally4skill = allyskill
			ally4_pos = ally_pos
			spell_select_ui.update_pos(ally4_pos+1)
		

	
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
	if ally1 != null:
		var spell_select_ui1 = ally1.get_spell_select()
		spell_select_ui1.update_pos(ally1_pos + 1)
	if ally2 != null:
		var spell_select_ui2 = ally2.get_spell_select()
		spell_select_ui2.update_pos(ally2_pos + 1)
	if ally3 != null:
		var spell_select_ui3 = ally3.get_spell_select()
		spell_select_ui3.update_pos(ally3_pos + 1)
	if ally4 != null:
		var spell_select_ui4 = ally4.get_spell_select()
		spell_select_ui4.update_pos(ally4_pos + 1)

func reset_skill_select():
	if ally1 != null:
		var spell_select_ui1 = ally1.get_spell_select()
		spell_select_ui1.reset()
		spell_select_ui1.update_pos(ally1_pos + 1)
	if ally2 != null:
		var spell_select_ui2 = ally2.get_spell_select()
		spell_select_ui2.reset()
		spell_select_ui2.update_pos(ally2_pos + 1)
	if ally3 != null:
		var spell_select_ui3 = ally3.get_spell_select()
		spell_select_ui3.reset()
		spell_select_ui3.update_pos(ally3_pos + 1)
	if ally4 != null:
		var spell_select_ui4 = ally4.get_spell_select()
		spell_select_ui4.reset()
		spell_select_ui4.update_pos(ally4_pos + 1)
	action_queue = []
	target_queue = []
	ally_queue = []
	next_pos = 0
	ally1_pos = -1
	ally2_pos = -1
	ally3_pos = -1
	ally4_pos = -1
	ally1skill = -1
	ally2skill = -1
	ally3skill = -1
	ally4skill = -1
	for ally in allies:
		ally.update_skills()

	update_skill_positions()
	
func _on_end_turn_pressed() -> void:
	if (!targeting and choosing_skills):
		#relics.add_relic(SHIELD_POTION)
		AudioPlayer.play_FX("click",0)
		# end of turn relics
		choosing_skills = false
		set_unit_pos()
		hide_skills()
		hide_ui()
		relics.activate_relics_by_type(Relic.Type.END_OF_TURN)

func _on_reset_choices_pressed() -> void:
	AudioPlayer.play_FX("click",0)
	action_queue = []
	target_queue = []
	ally_queue = []
	next_pos = 0
	ally1_pos = -1
	ally2_pos = -1
	ally3_pos = -1
	ally4_pos = -1
	reset_skill_select()
	update_skill_positions()

func show_skills():
	if ally1 != null:
		ally1.show_skills()
	if ally2 != null:
		ally2.show_skills()
	if ally3 != null:
		ally3.show_skills()
	if ally4 != null:
		ally4.show_skills()
	
func hide_skills():
	if ally1 != null:
		ally1.hide_skills()
	if ally2 != null:
		ally2.hide_skills()
	if ally3 != null:
		ally3.hide_skills()
	if ally4 != null:
		ally4.hide_skills()
	
func hide_ui():
	end_turn.visible = false
	reset_choices.visible = false
	
func show_ui():
	end_turn.visible = true
	reset_choices.visible = true
	
	
func choose_target(skill : Skill): 
	if (skill.target_type == "single_enemy" or skill.target_type == "single_ally"):
		var target
		targeting = true
		targeting_skill = skill
		toggle_targeting_ui(skill)
		hide_skills()
		hide_ui()
		Input.set_custom_mouse_cursor(TARGET_CURSOR, 0, Vector2(32,32))
		targeting_skill_info.visible = true
		targeting_label.visible = true
		if (not skill.friendly):
			for enemy in enemies:
				enemy.enable_targeting_area()
			new_spell_selected.emit()
			target = await target_chosen
			for enemy in enemies:
				enemy.disable_targeting_area()
		elif (skill.friendly):
			for ally in allies:
				ally.enable_targeting_area()
			new_spell_selected.emit()
			target = await target_chosen
			for ally in allies:
				ally.disable_targeting_area()
		show_skills()
		show_ui()
		toggle_targeting_ui(skill)
		AudioPlayer.play_FX("click",0)
		Input.set_custom_mouse_cursor(DEFAULT_CURSOR, 0)
		targeting = false
		return target
	else:
		return null
	
func target_signal(unit):
	target_chosen.emit(unit)

func _input(event):
	if event.is_action_pressed("1"):
		if (targeting):
			if (not targeting_skill.friendly):
				if (enemy1 != null):
					target_chosen.emit(enemy1)
			elif (targeting_skill.friendly and targeting):
				if (ally1 != null):
					target_chosen.emit(ally1)
	if event.is_action_pressed("2"):
		if (targeting):
			if (not targeting_skill.friendly and targeting):
				if (enemy2 != null):
					target_chosen.emit(enemy2)
			elif (targeting_skill.friendly and targeting):
				if (ally2 != null):
					target_chosen.emit(ally2)
	if event.is_action_pressed("3"):
		if (targeting):
			if (not targeting_skill.friendly and targeting):
				if (enemy3 != null):
					target_chosen.emit(enemy3)
			elif (targeting_skill.friendly and targeting):
				if (ally3 != null):
					target_chosen.emit(ally3)
	if event.is_action_pressed("4"):
		if (targeting):
			if (not targeting_skill.friendly and targeting):
				if (enemy4 != null):
					target_chosen.emit(enemy4)
			elif (targeting_skill.friendly and targeting):
				if (ally4 != null):
					target_chosen.emit(ally4)
	if event.is_action_pressed("end_turn"):
		_on_end_turn_pressed()
			
	
func toggle_targeting_ui(skill):
	targeting_skill_info.skill = skill
	targeting_skill_info.update_skill_info()
	targeting_skill_info.visible = !targeting_skill_info.visible
	targeting_label.visible = !targeting_label.visible
	

	
	
#activate statuses
func enemy_pre_status():
	for enemy in enemies:
		if enemy.status != []:
			for status in enemy.status:
				if status.pre_turn == 1:
					enemy.execute_status(status)

func enemy_post_status():
	for enemy in enemies:
		if enemy.status != []:
			for status in enemy.status:
				#if status.pre_turn == 0:
					enemy.execute_status(status)
		#remove any statuses with duration 0
		for i in range (len(enemy.status)-1): 
			if enemy.status[i].turns_remaining <= 0:
				enemy.status.remove_at(i)
				i -= 1
	
func ally_pre_status():
	for ally in allies:
		if ally.status != []:
			for status in ally.status:
				if status.pre_turn == 1:
					ally.execute_status(status)
	
func ally_post_status():
	for ally in allies:
		if ally.status != []:
			for status in ally.status:
				if status.pre_turn == 0:
					ally.execute_status(status)
					
func check_requirements():
	for ally in allies:
		var skill : Skill
		for i in range(1,4):
			match i:
				1:
					skill = ally.basic_atk
				2:
					skill = ally.skill_1
				3:
					skill = ally.skill_2
				4:
					skill = ally.ult
			if (skill):
				var check = false
				var tokens1 = 0
				var tokens2 = 0
				if skill.cost != null:
					match skill.token_type:
						"fire":
							tokens1 = GC.fire_tokens
						"water":
							tokens1 = GC.water_tokens
						"lightning":
							tokens1 = GC.lightning_tokens
						"grass":
							tokens1 = GC.grass_tokens
						"earth":
							tokens1 = GC.earth_tokens
				if skill.cost2 != null:
					match skill.token_type2:
						"fire":
							tokens2 = GC.fire_tokens
						"water":
							tokens2 = GC.water_tokens
						"lightning":
							tokens2 = GC.lightning_tokens
						"grass":
							tokens2 = GC.grass_tokens
						"earth":
							tokens2 = GC.earth_tokens
				if skill.cost != null:
					if skill.cost <= tokens1:
						check = true
					else:
						check = false
						
				if skill.cost2 != null:
					if skill.cost <= tokens1 and skill.cost2 <= tokens2:
						check = true
					else:
						check = false
				if skill.cost > 0 or skill.cost2 > 0:
					if check:
						ally.get_child(0).enable(i)
					else:
						ally.get_child(0).disable(i)
		
func set_unit_pos():
	for n in range(enemies.size()):
		if n > 0:
			enemies[n].left = enemies[n-1]
		else:
			enemies[n].left = null
		if n < enemies.size()-1:
			enemies[n].right = enemies[n+1]
		else:
			enemies[n].right = null
	for n in range(allies.size()):
		if n > 0:
			allies[n].left = allies[n-1]
		else:
			allies[n].left = null
		if n < allies.size()-1:
			allies[n].right = allies[n+1]
		else:
			allies[n].right = null
	if enemies.size() > 0:
		front_enemy = enemies[0]
		back_enemy = enemies[enemies.size()-1]
	if allies.size() > 0:
		front_ally = allies[allies.size()-1]
		back_ally = allies[0]
