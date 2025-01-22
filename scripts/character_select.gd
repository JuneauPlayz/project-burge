extends Node2D

const ALLY = preload("res://scenes/units/allies/ally.tscn")
const KATARA = preload("res://scenes/units/allies/Katara.tscn")
const PYROMANCER = preload("res://scenes/units/allies/Pyromancer.tscn")
const FREAK = preload("res://scenes/units/allies/Freak.tscn")
const DA_TING = preload("res://scenes/units/allies/DaTing.tscn") 

const BURGER_ENEMY = preload("res://scenes/units/enemies/burger_enemy.tscn")
const BAGUETTE = preload("res://scenes/units/enemies/baguette.tscn")

var ally_list = []
var ally_names = []
var enemy_list = []
var enemy_names = []

@onready var ally_list_label: Label = $AllyList
@onready var enemy_list_label: Label = $EnemyList

func _on_start_combat_pressed() -> void:
	ally_list.resize(4)
	enemy_list.resize(4)
	GC.load_combat(ally_list[0],ally_list[1],ally_list[2],ally_list[3],enemy_list[0],enemy_list[1],enemy_list[2],enemy_list[3])
	get_tree().change_scene_to_file("res://scenes/main scenes/combat.tscn")

# allies

func _on_pyromancer_pressed() -> void:
	ally_list.append(PYROMANCER)
	ally_names.append("Pyromancer")
	update_ally_list()
	
func _on_katara_pressed() -> void:
	ally_list.append(KATARA)
	ally_names.append("Katara")
	update_ally_list()

func _on_da_ting_pressed() -> void:
	ally_list.append(DA_TING)
	ally_names.append("DaTing")
	update_ally_list()

func _on_freak_pressed() -> void:
	ally_list.append(FREAK)
	ally_names.append("Freak")
	update_ally_list()

func _on_qiqi_pressed() -> void:
	ally_list.append(ALLY)
	ally_names.append("Qiqi")
	update_ally_list()
	
#enemies

func _on_burger_pressed() -> void:
	enemy_list.append(BURGER_ENEMY)
	enemy_names.append("Burger")
	update_enemy_list()

func _on_baguette_pressed() -> void:
	enemy_list.append(BAGUETTE)
	enemy_names.append("Baguette")
	update_enemy_list()

func update_ally_list():
	ally_list_label.text = "Ally List: " + str(ally_names)
	
func update_enemy_list():
	enemy_list_label.text = "Enemy List: " + str(enemy_names)
