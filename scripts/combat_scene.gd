extends Node2D

@onready var combat_manager: Node = %CombatManager
@onready var ally_1_spot: Node2D = %"Ally 1 Spot"
@onready var ally_2_spot: Node2D = %"Ally 2 Spot"
@onready var ally_3_spot: Node2D = %"Ally 3 Spot"
@onready var ally_4_spot: Node2D = %"Ally 4 Spot"
@onready var enemy_1_spot: Node2D = %"Enemy 1 Spot"
@onready var enemy_2_spot: Node2D = %"Enemy 2 Spot"
@onready var enemy_3_spot: Node2D = %"Enemy 3 Spot"
@onready var enemy_4_spot: Node2D = %"Enemy 4 Spot"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	combat_manager = get_child(1)
	load_units()
	combat_manager.combat_ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_combat_manager():
	return combat_manager

func load_units():
	var ally1 = Global.ally1.instantiate()
	var ally2 = Global.ally2.instantiate()
	var ally3 = Global.ally3.instantiate()
	var ally4 = Global.ally4.instantiate()
	var enemy1 = Global.enemy1.instantiate()
	var enemy2 = Global.enemy2.instantiate()
	var enemy3 = Global.enemy3.instantiate()
	var enemy4 = Global.enemy4.instantiate()
	ally_1_spot.add_child(ally1)
	ally_2_spot.add_child(ally2)
	ally_3_spot.add_child(ally3)
	ally_4_spot.add_child(ally4)
	enemy_1_spot.add_child(enemy1)
	enemy_2_spot.add_child(enemy2)
	enemy_3_spot.add_child(enemy3)
	enemy_4_spot.add_child(enemy4)
	combat_manager.ally1 = ally1
	combat_manager.ally2 = ally2
	combat_manager.ally3 = ally3
	combat_manager.ally4 = ally4
	combat_manager.enemy1 = enemy1
	combat_manager.enemy2 = enemy2
	combat_manager.enemy3 = enemy3
	combat_manager.enemy4 = enemy4
	
