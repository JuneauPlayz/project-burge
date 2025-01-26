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
@onready var loading: Node2D = $Loading
@onready var relic_handler_spot: Node2D = $RelicHandlerSpot

const RELIC_HANDLER = preload("res://scenes/relic handler/relic_handler.tscn")

var ally1 : Ally
var ally2 : Ally
var ally3 : Ally
var ally4 : Ally
var enemy1 : Enemy
var enemy2 : Enemy
var enemy3 : Enemy
var enemy4 : Enemy

var enemies = []
var allies = []

const ALLY = preload("res://scenes/units/allies/ally.tscn")
const ENEMY = preload("res://scenes/units/enemies/enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# loading
	loading.visible = true
	await get_tree().create_timer(0.5).timeout
	loading.visible = false
	# bg music
	var rng = RandomNumberGenerator.new()
	var random_num = rng.randi_range(1,4)
	match random_num:
		1:
			AudioPlayer.play_music("og", -32)
		2:
			AudioPlayer.play_music("zinnia", -32)
		3:
			AudioPlayer.play_music("crimson", -32)
		4:
			AudioPlayer.play_music("iris", -32)
	
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
	if GC.ally1 != null:
		var ally1s = ALLY.instantiate()
		ally1 = ally1s
		ally1s.res = GC.ally1
		ally_1_spot.add_child(ally1s)
		combat_manager.ally1 = ally1s
	if GC.ally2 != null:
		var ally2s = ALLY.instantiate()
		ally2 = ally2s
		ally2s.res = GC.ally2
		ally_2_spot.add_child(ally2s)
		combat_manager.ally2 = ally2s
	if GC.ally3 != null:
		var ally3s = ALLY.instantiate()
		ally3 = ally3s
		ally3s.res = GC.ally3
		ally_3_spot.add_child(ally3s)
		combat_manager.ally3 = ally3s
	if GC.ally4 != null:
		var ally4s = ALLY.instantiate()
		ally4 = ally4s
		ally4s.res = GC.ally4
		ally_4_spot.add_child(ally4s)
		combat_manager.ally4 = ally4s
	if GC.enemy1 != null:
		var enemy1s = ENEMY.instantiate()
		enemy1 = enemy1s
		enemy1s.res = GC.enemy1
		enemy_1_spot.add_child(enemy1s)
		combat_manager.enemy1 = enemy1s
	if GC.enemy2 != null:
		var enemy2s = ENEMY.instantiate()
		enemy2 = enemy2s
		enemy2s.res = GC.enemy2
		enemy_2_spot.add_child(enemy2s)
		combat_manager.enemy2 = enemy2s
	if GC.enemy3 != null:
		var enemy3s = ENEMY.instantiate()
		enemy3 = enemy3s
		enemy3s.res = GC.enemy3
		enemy_3_spot.add_child(enemy3s)
		combat_manager.enemy3 = enemy3s
	if GC.enemy4 != null:
		var enemy4s = ENEMY.instantiate()
		enemy4 = enemy4s
		enemy4s.res = GC.enemy4
		enemy_4_spot.add_child(enemy4s)
		combat_manager.enemy4 = enemy4s
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
	if (GC.relics != null):
		# loads relics
		var new_relic_handler = RELIC_HANDLER.instantiate()
		relic_handler_spot.add_child(new_relic_handler)
		for relic in GC.relics:
			new_relic_handler.add_relic(relic)
		combat_manager.relics = new_relic_handler
		
		

	
