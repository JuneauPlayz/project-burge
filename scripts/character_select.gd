extends Node2D

const CHARIZARD = preload("res://resources/units/allies/Charizard.tres")
const BLASTOISE = preload("res://resources/units/allies/Blastoise.tres")
const VENASAUR = preload("res://resources/units/allies/Venasaur.tres")
const PIKACHU = preload("res://resources/units/allies/Pikachu.tres")

const BAGUETTE = preload("res://resources/units/enemies/Baguette.tres")
const BURGER = preload("res://resources/units/enemies/Burger.tres")

const RELIC_HANDLER = preload("res://scenes/relic handler/relic_handler.tscn")

const SHIELD_POTION = preload("res://resources/relics/shield_potion.tres")
const FIRE_POTION = preload("res://resources/relics/fire_potion.tres")
const VAPOR_ORB = preload("res://resources/relics/vapor_orb.tres")

var ally_list = []
var ally_names = []
var enemy_list = []
var enemy_names = []

var relic_list = []
@onready var ally_list_label: Label = $AllyList
@onready var enemy_list_label: Label = $EnemyList
@onready var relic_list_label: Label = $Relics/RelicList
	
func _on_start_combat_pressed() -> void:
	ally_list.resize(4)
	enemy_list.resize(4)
	#GC.load_combat(ally_list[0],ally_list[1],ally_list[2],ally_list[3],enemy_list[0],enemy_list[1],enemy_list[2],enemy_list[3],10)
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
	
func add_relic(res, name):
	relic_list.append(name)
	GC.relics.append(res)
	update_relic_list()
	
func _on_charizard_pressed() -> void:
	add_ally(CHARIZARD,"CHARIZARD")
	

func update_ally_list():
	AudioPlayer.play_FX("click",0)
	ally_list_label.text = "Ally List: " + str(ally_names)
	
func update_enemy_list():
	AudioPlayer.play_FX("click",0)
	enemy_list_label.text = "Enemy List: " + str(enemy_names)

func update_relic_list():
	AudioPlayer.play_FX("click",0)
	relic_list_label.text = "Relic List: " + str(relic_list)

func _on_blastoise_pressed() -> void:
	add_ally(BLASTOISE, "BLASTOISE")


func _on_venasaur_pressed() -> void:
	add_ally(VENASAUR, "VENASAUR")


func _on_burger_pressed() -> void:
	add_enemy(BURGER, "burger")
	
func _on_baguette_pressed() -> void:
	add_enemy(BAGUETTE, "Baguette")


func _on_pikachu_pressed() -> void:
	add_ally(PIKACHU, "PIKACHU")


func _on_shield_pressed() -> void:
	add_relic(SHIELD_POTION, "Shield Potion")


func _on_fire_pressed() -> void:
	add_relic(FIRE_POTION, "Fire Potion")


func _on_vapor_pressed() -> void:
	add_relic(VAPOR_ORB, "Vapor Orb")
