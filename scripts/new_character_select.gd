extends Node2D
@onready var charizard: Draggable = $GridContainer/Charizard
@onready var blastoise: Draggable = $GridContainer/Blastoise
@onready var venasaur: Draggable = $GridContainer/Venasaur
@onready var pikachu: Draggable = $GridContainer/Pikachu

const CHARIZARD = preload("res://resources/units/allies/Charizard.tres")
const BLASTOISE = preload("res://resources/units/allies/Blastoise.tres")
const VENASAUR = preload("res://resources/units/allies/Venasaur.tres")
const PIKACHU = preload("res://resources/units/allies/Pikachu.tres")

var charizard_spot
var blastoise_spot
var venasaur_spot
var pikachu_spot

const BAGUETTE = preload("res://resources/units/enemies/Baguette.tres")
const BURGER_ENEMY = preload("res://resources/units/enemies/Burger.tres")

var characters = []
var character_res_list = []
@onready var ally_1_spot: ColorRect = $GridContainer/Ally1Spot
@onready var ally_2_spot: ColorRect = $GridContainer/Ally2Spot
@onready var ally_3_spot: ColorRect = $GridContainer/Ally3Spot
@onready var ally_4_spot: ColorRect = $GridContainer/Ally4Spot

var ally1
var ally2
var ally3
var ally4


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	characters.append(charizard)
	characters.append(blastoise)
	characters.append(venasaur)
	characters.append(pikachu)
	
	character_res_list.append(CHARIZARD)
	character_res_list.append(BLASTOISE)
	character_res_list.append(VENASAUR)
	character_res_list.append(PIKACHU)
	update_positions()
	_on_charizard_drag_ended()
	_on_blastoise_drag_ended()
	_on_venasaur_drag_ended()
	_on_pikachu_drag_ended()

func update_positions():
	if charizard:
		charizard_spot = charizard.global_position
	if blastoise:
		blastoise_spot = blastoise.global_position
	if venasaur:
		venasaur_spot = venasaur.global_position
	if pikachu:
		pikachu_spot = pikachu.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass





func _on_begin_run_pressed() -> void:
	for i in range(characters.size()):
		if characters[i].global_position == ally_1_spot.global_position:
			ally1 = character_res_list[i]
		elif characters[i].global_position == ally_2_spot.global_position:
			ally2 = character_res_list[i]
		elif characters[i].global_position == ally_3_spot.global_position:
			ally3 = character_res_list[i]
		elif characters[i].global_position == ally_4_spot.global_position:
			ally4 = character_res_list[i]
	GC.load_combat(ally1,ally2,ally3,ally4,GC.fight_1[0],GC.fight_1[1],GC.fight_1[2],GC.fight_1[3],10)
	get_tree().change_scene_to_file("res://scenes/main scenes/combat.tscn")

func check_spot(char, og_spot):
	update_positions()
	for character in characters:
		if char != character:
			if char.global_position == character.global_position:
				char.global_position = og_spot
				update_positions()

func _on_charizard_drag_ended() -> void:
	print("hello" + str(charizard_spot))
	if charizard:
		print("Hi" + str(charizard.global_position))
	print()
	check_spot(charizard, charizard_spot)


func _on_blastoise_drag_ended() -> void:
	check_spot(blastoise, blastoise_spot)


func _on_venasaur_drag_ended() -> void:
	check_spot(venasaur, venasaur_spot)


func _on_pikachu_drag_ended() -> void:
	check_spot(pikachu, pikachu_spot)
