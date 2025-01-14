extends Node2D

const ALLY = preload("res://scenes/units/allies/ally.tscn")
const KATARA = preload("res://scenes/units/allies/Katara.tscn")
const PYROMANCER = preload("res://scenes/units/allies/Pyromancer.tscn")
const FREAK = preload("res://scenes/units/allies/Freak.tscn")
const DA_TING = preload("res://scenes/units/allies/DaTing.tscn") 

const BURGER_ENEMY = preload("res://scenes/units/enemies/burger_enemy.tscn")
const BAGUETTE = preload("res://scenes/units/enemies/baguette.tscn")



func _on_start_combat_pressed() -> void:
	Global.load_combat(KATARA,PYROMANCER,FREAK,DA_TING,BURGER_ENEMY,BAGUETTE,BURGER_ENEMY,BAGUETTE)
	get_tree().change_scene_to_file("res://scenes/main scenes/combat.tscn")
