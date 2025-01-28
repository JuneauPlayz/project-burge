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
@onready var item_1_spot: Node2D = $Item1Spot
@onready var item_2_spot: Node2D = $Item2Spot
@onready var item_3_spot: Node2D = $Item3Spot

var spot_list = []
var relics : RelicHandler

@onready var gold_label: Label = $Gold
@onready var confirm_swap: Button = $ConfirmSwap

var new_skill : Skill
var new_skill_ally : Ally

signal swap_done

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioPlayer.play_music("wii_shop", -30)
	load_units()
	update_gold()
	spot_list.append(item_1_spot)
	spot_list.append(item_2_spot)
	spot_list.append(item_3_spot)
	for spot in spot_list:
		var item = spot.get_child(0)
		item.update_item()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_units():
	print("loading units")
	if GC.ally1 != null:
		var ally1s = ALLY.instantiate()
		ally1 = ally1s
		ally1s.res = GC.ally1
		ally1.ally_num = 1
		ally_1_spot.add_child(ally1s)
	if GC.ally2 != null:
		var ally2s = ALLY.instantiate()
		ally2 = ally2s
		ally2s.res = GC.ally2
		ally2.ally_num = 2
		ally_2_spot.add_child(ally2s)
	if GC.ally3 != null:
		var ally3s = ALLY.instantiate()
		ally3 = ally3s
		ally3s.res = GC.ally3
		ally3.ally_num = 3
		ally_3_spot.add_child(ally3s)
	if GC.ally4 != null:
		var ally4s = ALLY.instantiate()
		ally4 = ally4s
		ally4s.res = GC.ally4
		ally4.ally_num = 4
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
		ally.shop = true
		ally.spell_select_ui.enable_all()
		ally.spell_select_ui.hide_position()
		ally.update_vars()
		ally.show_level_up(1)
	if (GC.relics != null):
		# loads relics
		var new_relic_handler = RELIC_HANDLER.instantiate()
		relic_handler_spot.add_child(new_relic_handler)
		relics = new_relic_handler
		for relic in GC.relics:
			new_relic_handler.add_relic(relic)


func item_bought(item, shop_item) -> void:
	if item is Relic:
		relics.add_relic(item)
		GC.relics.append(item)
	elif item is Skill:
		new_skill = item
		buying_new_skill(shop_item)
			
	update_gold()
	
func buying_new_skill(shop_item):
	new_skill_ally = null
	for ally in allies:
		ally.level_up_reward.visible = false
	for spot in spot_list:
			spot.visible = false
	shop_item.get_parent().visible = true
	confirm_swap.visible = true
	shop_item.hide_buy()
	await swap_done
	for ally in allies:
		ally.level_up_reward.visible = true
	for spot in spot_list:
		spot.visible = true
	confirm_swap.visible = false
	shop_item.show_buy()
	

func update_gold():
	gold_label.text = "Gold: " + str(GC.gold)


func _on_next_combat_pressed() -> void:
	GC.load_combat(GC.ally1,GC.ally2,GC.ally3,GC.ally4,GC.enemy1,GC.enemy2,GC.enemy3,GC.enemy4)
	get_tree().change_scene_to_file("res://scenes/main scenes/combat.tscn")
	
func _on_confirm_swap_pressed() -> void:
	if (new_skill_ally):
		new_skill_ally.skill_swap_2 = new_skill
		new_skill_ally._on_confirm_swap_pressed()
		swap_done.emit()
