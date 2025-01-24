extends Node2D

const CHARIZARD = preload("res://scenes/units/allies/Charizard.tres")
const BLASTOISE = preload("res://scenes/units/allies/Blastoise.tres")
const VENASAUR = preload("res://scenes/units/allies/Venasaur.tres")

const BURGER_ENEMY = preload("res://scenes/units/enemies/burger_enemy.tscn")
const BAGUETTE = preload("res://scenes/units/enemies/baguette.tscn")

@onready var click: AudioStreamPlayer2D = $AudioStreamPlayer2D

var ally_list = []
var ally_names = []
var enemy_list = []
var enemy_names = []

@onready var ally_list_label: Label = $AllyList
@onready var enemy_list_label: Label = $EnemyList

func _ready():
	click.play()
	

func _on_start_combat_pressed() -> void:
	ally_list.resize(4)
	enemy_list.resize(4)
	GC.load_combat(ally_list[0],ally_list[1],ally_list[2],ally_list[3],enemy_list[0],enemy_list[1],enemy_list[2],enemy_list[3])
	get_tree().change_scene_to_file("res://scenes/main scenes/combat.tscn")

# allies
func add_ally(res, name):
	ally_list.append(res)
	ally_names.append(name)
	update_ally_list()
	
func add_enemy(res, name):
	enemy_list.append(res)
	enemy_names.append(name)
	update_enemy_list()
	
func _on_charizard_pressed() -> void:
	add_ally(CHARIZARD,"CHARIZARD")
	

func update_ally_list():
	click.play()
	ally_list_label.text = "Ally List: " + str(ally_names)
	
func update_enemy_list():
	click.play()
	enemy_list_label.text = "Enemy List: " + str(enemy_names)


func _on_blastoise_pressed() -> void:
	add_ally(BLASTOISE, "BLASTOISE")


func _on_venasaur_pressed() -> void:
	add_ally(VENASAUR, "VENASAUR")


func _on_burger_pressed() -> void:
	add_enemy(BURGER_ENEMY, "burger")
	
func _on_baguette_pressed() -> void:
	add_enemy(BAGUETTE, "Baguette")
