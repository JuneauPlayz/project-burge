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
	print("loading units")
	if Global.ally1 != null:
		var ally1 = Global.ally1.instantiate()
		ally_1_spot.add_child(ally1)
		combat_manager.ally1 = ally1
	if Global.ally2 != null:
		var ally2 = Global.ally2.instantiate()
		ally_2_spot.add_child(ally2)
		combat_manager.ally2 = ally2
	if Global.ally3 != null:
		var ally3 = Global.ally3.instantiate()
		ally_3_spot.add_child(ally3)
		combat_manager.ally3 = ally3
	if Global.ally4 != null:
		var ally4 = Global.ally4.instantiate()
		ally_4_spot.add_child(ally4)
		combat_manager.ally4 = ally4
	if Global.enemy1 != null:
		var enemy1 = Global.enemy1.instantiate()
		enemy_1_spot.add_child(enemy1)
		combat_manager.enemy1 = enemy1
	if Global.enemy2 != null:
		var enemy2 = Global.enemy2.instantiate()
		enemy_2_spot.add_child(enemy2)
		combat_manager.enemy2 = enemy2
	if Global.enemy3 != null:
		var enemy3 = Global.enemy3.instantiate()
		enemy_3_spot.add_child(enemy3)
		combat_manager.enemy3 = enemy3
	if Global.enemy4 != null:
		var enemy4 = Global.enemy4.instantiate()
		enemy_4_spot.add_child(enemy4)
		combat_manager.enemy4 = enemy4

	
