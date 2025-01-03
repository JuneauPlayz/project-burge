extends Node

@export var ally1 : Ally
@export var ally2 : Ally
@export var ally3 : Ally
@export var ally4 : Ally
@export var enemy1 : Enemy

@export var action_queue = []
@export var queue_counter : int = 0
@export var ally1_lock = 0
@export var ally2_lock = 0
@export var ally3_lock = 0
@export var ally4_lock = 0

func execute_turn():
	for x in action_queue:
		if x == ally1.basic_atk:
			ally1_basic()
		elif x == ally1.skill_1:
			ally1_skill1()
		elif x == ally1.skill_2:
			ally1_skill2()
		elif x == ally1.ult:
			ally1_ult()
		elif x == ally2.basic_atk:
			ally1_basic()
		elif x == ally2.skill_1:
			ally1_skill1()
		elif x == ally2.skill_2:
			ally1_skill2()
		elif x == ally2.ult:
			ally1_ult()
		elif x == ally3.basic_atk:
			ally1_basic()
		elif x == ally3.skill_1:
			ally1_skill1()
		elif x == ally3.skill_2:
			ally1_skill2()
		elif x == ally3.ult:
			ally1_ult()
		elif x == ally4.basic_atk:
			ally1_basic()
		elif x == ally4.skill_1:
			ally1_skill1()
		elif x == ally4.skill_2:
			ally1_skill2()
		elif x == ally4.ult:
			ally1_ult()
		await get_tree().create_timer(1).timeout

#action functions
func ally1_basic():
	var skill = ally1.basic_atk
	enemy1.take_element(skill.element)
	enemy1.take_damage(skill.damage)
	
	#testing output
	print("basic attack landed! remaining hp: " + str(enemy1.health))

func ally1_skill1():
	var skill = ally1.skill_1
	enemy1.take_element(skill.element)
	enemy1.take_damage(skill.damage)
	print("skill 1 landed! remaining hp: " + str(enemy1.health))
	
func ally1_skill2():
	var skill = ally1.skill_2
	enemy1.take_element(skill.element)
	enemy1.take_damage(skill.damage)
	print("skill 2 landed! remaining hp: " + str(enemy1.health))
	
func ally1_ult():
	var skill = ally1.ult
	enemy1.take_element(skill.element)
	enemy1.take_damage(skill.damage)
	print("ultimate landed! remaining hp: " + str(enemy1.health))
	
func ally2_basic():
	var skill = ally2.basic_atk
	enemy1.take_element(skill.element)
	enemy1.take_damage(skill.damage)
	print("basic attack landed! remaining hp: " + str(enemy1.health))

func ally2_skill1():
	var skill = ally2.skill_1
	enemy1.take_element(skill.element)
	enemy1.take_damage(skill.damage)
	print("skill 1 landed! remaining hp: " + str(enemy1.health))
	
func ally2_skill2():
	var skill = ally2.skill_2
	enemy1.take_element(skill.element)
	enemy1.take_damage(skill.damage)
	print("skill 2 landed! remaining hp: " + str(enemy1.health))
	
func ally2_ult():
	var skill = ally2.ult
	enemy1.take_element(skill.element)
	enemy1.take_damage(skill.damage)
	print("ultimate landed! remaining hp: " + str(enemy1.health))
	
func ally3_basic():
	var skill = ally3.basic_atk
	enemy1.take_element(skill.element)
	enemy1.take_damage(skill.damage)
	print("basic attack landed! remaining hp: " + str(enemy1.health))

func ally3_skill1():
	var skill = ally3.skill_1
	enemy1.take_element(skill.element)
	enemy1.take_damage(skill.damage)
	print("skill 1 landed! remaining hp: " + str(enemy1.health))
	
func ally3_skill2():
	var skill = ally3.skill_2
	enemy1.take_element(skill.element)
	enemy1.take_damage(skill.damage)
	print("skill 2 landed! remaining hp: " + str(enemy1.health))
	
func ally3_ult():
	var skill = ally3.ult
	enemy1.take_element(skill.element)
	enemy1.take_damage(skill.damage)
	print("ultimate landed! remaining hp: " + str(enemy1.health))
	
func ally4_basic():
	var skill = ally4.basic_atk
	enemy1.take_element(skill.element)
	enemy1.take_damage(skill.damage)
	print("basic attack landed! remaining hp: " + str(enemy1.health))

func ally4_skill1():
	var skill = ally4.skill_1
	enemy1.take_element(skill.element)
	enemy1.take_damage(skill.damage)
	print("skill 1 landed! remaining hp: " + str(enemy1.health))
	
func ally4_skill2():
	var skill = ally4.skill_2
	enemy1.take_element(skill.element)
	enemy1.take_damage(skill.damage)
	print("skill 2 landed! remaining hp: " + str(enemy1.health))
	
func ally4_ult():
	var skill = ally4.ult
	enemy1.take_element(skill.element)
	enemy1.take_damage(skill.damage)
	print("ultimate landed! remaining hp: " + str(enemy1.health))

#ally 1 action queueing
func _on_ba_1_pressed() -> void:
	if ally1_lock == 0:
		action_queue.append(ally1.basic_atk)
		ally1_lock = 1
		queue_counter += 1
		if len(action_queue) == 4:
			execute_turn()
	else:
		pass

func _on_s_1_1_pressed() -> void:
	if ally1_lock == 0:
		action_queue.append(ally1.skill_1)
		ally1_lock = 1
		queue_counter += 1
		if len(action_queue) == 4:
			execute_turn()
	else:
		pass

func _on_s_2_1_pressed() -> void:
	if ally1_lock == 0:
		action_queue.append(ally1.skill_2)
		ally1_lock = 1
		queue_counter += 1
		if len(action_queue) == 4:
			execute_turn()
	else:
		pass

func _on_ult_1_pressed() -> void:
	if ally1_lock == 0:
		action_queue.append(ally1.ult)
		ally1_lock = 1
		queue_counter += 1
		if len(action_queue) == 4:
			execute_turn()
	else:
		pass
#ally 2 action queueing
func _on_ba_2_pressed() -> void:
	if ally2_lock == 0:
		action_queue.append(ally2.basic_atk)
		ally2_lock = 1
		queue_counter += 1
		if len(action_queue) == 4:
			execute_turn()
	else:
		pass


func _on_s_1_2_pressed() -> void:
	if ally2_lock == 0:
		action_queue.append(ally2.skill_1)
		ally2_lock = 1
		queue_counter += 1
		if len(action_queue) == 4:
			execute_turn()
	else:
		pass


func _on_s_2_2_pressed() -> void:
	if ally2_lock == 0:
		action_queue.append(ally2.skill_2)
		ally2_lock = 1
		queue_counter += 1
		if len(action_queue) == 4:
			execute_turn()
	else:
		pass


func _on_ult_2_pressed() -> void:
	if ally2_lock == 0:
		action_queue.append(ally2.ult)
		ally2_lock = 1
		queue_counter += 1
		if len(action_queue) == 4:
			execute_turn()
	else:
		pass

#ally 3 action queueing
func _on_ba_3_pressed() -> void:
	if ally3_lock == 0:
		action_queue.append(ally3.basic_atk)
		ally3_lock = 1
		queue_counter += 1
		if len(action_queue) == 4:
			execute_turn()
	else:
		pass


func _on_s_1_3_pressed() -> void:
	if ally3_lock == 0:
		action_queue.append(ally3.skill_1)
		ally3_lock = 1
		queue_counter += 1
		if len(action_queue) == 4:
			execute_turn()
	else:
		pass


func _on_s_2_3_pressed() -> void:
	if ally3_lock == 0:
		action_queue.append(ally3.skill_2)
		ally3_lock = 1
		queue_counter += 1
		if len(action_queue) == 4:
			execute_turn()
	else:
		pass


func _on_ult_3_pressed() -> void:
	if ally3_lock == 0:
		action_queue.append(ally3.ult)
		ally3_lock = 1
		queue_counter += 1
		if len(action_queue) == 4:
			execute_turn()
	else:
		pass

#ally 4 action queueing
func _on_ba_4_pressed() -> void:
	if ally4_lock == 0:
		action_queue.append(ally4.basic_atk)
		ally4_lock = 1
		queue_counter += 1
		if len(action_queue) == 4:
			execute_turn()
	else:
		pass


func _on_s_1_4_pressed() -> void:
	if ally4_lock == 0:
		action_queue.append(ally4.skill_1)
		ally4_lock = 1
		queue_counter += 1
		if len(action_queue) == 4:
			execute_turn()
	else:
		pass


func _on_s_2_4_pressed() -> void:
	if ally4_lock == 0:
		action_queue.append(ally4.skill_2)
		ally4_lock = 1
		queue_counter += 1
		if len(action_queue) == 4:
			execute_turn()
	else:
		pass


func _on_ult_4_pressed() -> void:
	if ally4_lock == 0:
		action_queue.append(ally4.ult)
		ally4_lock = 1
		queue_counter += 1
		if len(action_queue) == 4:
			execute_turn()
	else:
		pass
