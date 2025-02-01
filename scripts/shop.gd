extends Node2D

@onready var relic_handler_spot: Node2D = $RelicHandlerSpot
const RELIC_HANDLER = preload("res://scenes/relic handler/relic_handler.tscn")

const SHOP_ITEM = preload("res://scenes/reusables/shop_item.tscn")

var ally1 : Ally
var ally2 : Ally
var ally3 : Ally
var ally4 : Ally

var allies = []

const ALLY = preload("res://resources/units/allies/ally.tscn")
const ENEMY = preload("res://resources/units/enemies/enemy.tscn")

@onready var reaction_panel: Control = $ReactionGuide/ReactionPanel
@onready var relic_info: Control = %RelicInfo

@onready var ally_1_spot: Node2D = $"Ally 1 Spot"
@onready var ally_2_spot: Node2D = $"Ally 2 Spot"
@onready var ally_3_spot: Node2D = $"Ally 3 Spot"
@onready var ally_4_spot: Node2D = $"Ally 4 Spot"

@onready var relic_1_spot: Node2D = $Relic1Spot
@onready var relic_2_spot: Node2D = $Relic2Spot
@onready var relic_3_spot: Node2D = $Relic3Spot

@onready var spell_1_spot: Node2D = $Spell1Spot
@onready var spell_2_spot: Node2D = $Spell2Spot
@onready var spell_3_spot: Node2D = $Spell3Spot

var relic_list = []
var spell_list = []

var shop_relics = []
var shop_skills = []

var relics : RelicHandler

@onready var gold_label: Label = $Gold
@onready var confirm_swap: Button = $ConfirmSwap
@onready var next_combat: Button = $NextCombat

var new_skill : Skill
var new_skill_ally : Ally

signal swap_done

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioPlayer.play_music("wii_shop", -30)
	load_units()
	update_gold()
	relic_list.append(relic_1_spot)
	relic_list.append(relic_2_spot)
	relic_list.append(relic_3_spot)
	
	spell_list.append(spell_1_spot)
	spell_list.append(spell_2_spot)
	spell_list.append(spell_3_spot)
	
	for spot in relic_list:
		var item = SHOP_ITEM.instantiate()
		spot.add_child(item)
		item.item = GC.get_random_relic()
		if GC.obtainable_relics.size() > 2:
			while item.item in shop_relics:
				item.item = GC.get_random_relic()
			item.price = get_price(item.item)
			item.update_item()
			shop_relics.append(item.item)
		
	for spot in spell_list:
		var item = SHOP_ITEM.instantiate()
		spot.add_child(item)
		item.item = GC.get_random_skill()
		if GC.obtainable_skills.size() > 2:
			while item.item in shop_skills:
				item.item = GC.get_random_skill()
			item.price = get_price(item.item)
			item.update_item()
			shop_skills.append(item.item)
		item.skill_info.z_index -= 1
		

func get_price(resource):
	match resource.tier:
		"1":
			return 3
		"2":
			return 6
		"3":
			return 10

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
	await get_tree().create_timer(0.3).timeout
	if GC.current_fight == GC.fight_1:
		GC.level_up_allies()
	for ally in allies:
		ally.update_vars()
		if ally.level_up == true:
			ally.show_level_up(ally.level)
			print("level" + str(ally.level))

	if (GC.relics != null):
		# loads relics
		var new_relic_handler = RELIC_HANDLER.instantiate()
		relic_handler_spot.add_child(new_relic_handler)
		relics = new_relic_handler
		for relic in GC.relics:
			new_relic_handler.add_relic(relic)


func item_bought(item, shop_item) -> void:
	if item is Relic:
		relics.purchase_relic(item)
		GC.relics.append(item)
		shop_item.queue_free()
	elif item is Skill:
		new_skill = item
		buying_new_skill(shop_item)
		shop_item.queue_free()
			
	update_gold()
	
func buying_new_skill(shop_item):
	new_skill_ally = null
	for ally in allies:
		ally.level_up_reward.visible = false
		ally.spell_select_ui.reset()
	for spot in relic_list:
		spot.visible = false
	for spot in spell_list:
		spot.visible = false
	shop_item.get_parent().visible = true
	confirm_swap.visible = true
	shop_item.hide_buy()
	next_combat.visible = false
	await swap_done
	for ally in allies:
		if ally.level_up and not ally.level_up_complete:
			ally.level_up_reward.visible = true
		else:
			ally.level_up_reward.visible = false
	for spot in relic_list:
		spot.visible = true
	for spot in spell_list:
		spot.visible = true
	confirm_swap.visible = false
	next_combat.visible = true

func update_gold():
	gold_label.text = "Gold: " + str(GC.gold)


func _on_next_combat_pressed() -> void:
	for ally in allies:
		ally.level_up = false
	GC.disable_level_ups()
	AudioPlayer.play_FX("click",-10)
	GC.next_fight()
	GC.load_combat(GC.ally1,GC.ally2,GC.ally3,GC.ally4,GC.current_fight[0],GC.current_fight[1],GC.current_fight[2],GC.current_fight[3])
	get_tree().change_scene_to_file("res://scenes/main scenes/combat.tscn")
	
func _on_confirm_swap_pressed() -> void:
	AudioPlayer.play_FX("click",-10)
	if (new_skill_ally):
		new_skill_ally.skill_swap_2 = new_skill
		new_skill_ally._on_confirm_swap_pressed()
		swap_done.emit()


func _on_reaction_guide_pressed() -> void:
	if reaction_panel.visible:
		reaction_panel.visible = false
	elif not reaction_panel.visible:
		reaction_panel.visible = true


func toggle_relic_tooltip():
	relic_info.visible = !relic_info.visible
