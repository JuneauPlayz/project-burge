extends Node

@export var ally1 : Ally
@export var ally2 : Ally
@export var ally3 : Ally
@export var ally4 : Ally
@export var enemy1 : Enemy

@export var action_queue = []



func _on_s_1_pressed() -> void:
	var skill = ally1.skill_1
	enemy1.take_element(skill.element)
	enemy1.take_damage(skill.damage)
	print("skill 1 landed! remaining hp: " + str(enemy1.health))


func _on_s_2_pressed() -> void:
	var skill = ally1.skill_2
	enemy1.take_element(skill.element)
	enemy1.take_damage(skill.damage)
	print("skill 2 landed! remaining hp: " + str(enemy1.health))



func _on_ult_pressed() -> void:
	var skill = ally1.ult
	enemy1.take_element(skill.element)
	enemy1.take_damage(skill.damage)
	print("ultimate landed! remaining hp: " + str(enemy1.health))


func _on_basic_pressed() -> void:
	var skill = ally1.basic_atk
	var damage : float
	enemy1.take_element(skill.element)
	enemy1.take_damage(skill.damage)
	
	#testing output
	print("basic attack landed! remaining hp: " + str(enemy1.health))
