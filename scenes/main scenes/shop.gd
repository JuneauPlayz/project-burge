extends Node2D

@onready var relic_handler_spot: Node2D = $RelicHandlerSpot
const RELIC_HANDLER = preload("res://scenes/relic handler/relic_handler.tscn")

var ally1 : Ally
var ally2 : Ally
var ally3 : Ally
var ally4 : Ally

var allies = []

const ALLY = preload("res://scenes/units/allies/ally.tscn")
const ENEMY = preload("res://scenes/units/enemies/enemy.tscn")

@onready var ally_1_spot: Node2D = $"Ally 1 Spot"
@onready var ally_2_spot: Node2D = $"Ally 2 Spot"
@onready var ally_3_spot: Node2D = $"Ally 3 Spot"
@onready var ally_4_spot: Node2D = $"Ally 4 Spot"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_units()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_units():
	print("loading units")
	if GC.ally1 != null:
		var ally1s = ALLY.instantiate()
		ally1 = ally1s
		ally1s.res = GC.ally1
		ally_1_spot.add_child(ally1s)
	if GC.ally2 != null:
		var ally2s = ALLY.instantiate()
		ally2 = ally2s
		ally2s.res = GC.ally2
		ally_2_spot.add_child(ally2s)
	if GC.ally3 != null:
		var ally3s = ALLY.instantiate()
		ally3 = ally3s
		ally3s.res = GC.ally3
		ally_3_spot.add_child(ally3s)
	if GC.ally4 != null:
		var ally4s = ALLY.instantiate()
		ally4 = ally4s
		ally4s.res = GC.ally4
		ally_4_spot.add_child(ally4s)
	
	if (ally1 != null):
		allies.append(ally1)
	if (ally2 != null):
		allies.append(ally2)
	if (ally3 != null):
		allies.append(ally3)
	if (ally4 != null):
		allies.append(ally4)
	for ally in allies:
		ally.combat = false
	if (GC.relics != null):
		# loads relics
		var new_relic_handler = RELIC_HANDLER.instantiate()
		relic_handler_spot.add_child(new_relic_handler)
		for relic in GC.relics:
			new_relic_handler.add_relic(relic)
