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
@onready var reaction_panel: Control = $CombatManager/ReactionGuide/ReactionPanel
@onready var combat_currency: Control = $CombatManager/CombatCurrency
@onready var end_turn: Button = $EndTurn


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
@onready var relic_info: Control = %RelicInfo

const ALLY = preload("res://resources/units/allies/ally.tscn")
const ENEMY = preload("res://resources/units/enemies/enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# loading
	loading.visible = true
	await get_tree().create_timer(0.35).timeout
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
	await get_tree().create_timer(0.15).timeout
	loading.visible = false
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_combat_manager():
	return combat_manager

func load_units():
	enemy1 = null
	enemy2 = null
	enemy3 = null
	enemy4 = null
	# temp fix
	if GC.disable_level_up == true:
		if GC.ally1 != null:
			GC.ally1.level_up = false
		if GC.ally2 != null:
			GC.ally2.level_up = false
		if GC.ally3 != null:
			GC.ally3.level_up = false
		if GC.ally4 != null:
			GC.ally4.level_up = false
		GC.disable_level_up = false
	GC.skills = []
	print("loading units")
	if GC.ally1 != null:
		var ally1s = ALLY.instantiate()
		ally1 = ally1s
		ally1s.res = GC.ally1
		GC.ally1.ally_num = 1
		ally_1_spot.add_child(ally1s)
		combat_manager.ally1 = ally1s
		GC.combat_ally1 = ally1s
		GC.skills.append(GC.ally1.skill1)
		GC.skills.append(GC.ally1.skill2)
		GC.skills.append(GC.ally1.skill3)
		GC.skills.append(GC.ally1.skill4)
	if GC.ally2 != null:
		var ally2s = ALLY.instantiate()
		ally2 = ally2s
		ally2s.res = GC.ally2
		GC.ally2.ally_num = 2
		ally_2_spot.add_child(ally2s)
		combat_manager.ally2 = ally2s
		GC.combat_ally2 = ally2s
		GC.skills.append(GC.ally2.skill1)
		GC.skills.append(GC.ally2.skill2)
		GC.skills.append(GC.ally2.skill3)
		GC.skills.append(GC.ally2.skill4)
	if GC.ally3 != null:
		var ally3s = ALLY.instantiate()
		ally3 = ally3s
		ally3s.res = GC.ally3
		GC.ally3.ally_num = 3
		ally_3_spot.add_child(ally3s)
		combat_manager.ally3 = ally3s
		GC.combat_ally3 = ally3s
		GC.skills.append(GC.ally3.skill1)
		GC.skills.append(GC.ally3.skill2)
		GC.skills.append(GC.ally3.skill3)
		GC.skills.append(GC.ally3.skill4)
	if GC.ally4 != null:
		var ally4s = ALLY.instantiate()
		ally4 = ally4s
		ally4s.res = GC.ally4
		GC.ally4.ally_num = 4
		ally_4_spot.add_child(ally4s)
		combat_manager.ally4 = ally4s
		GC.combat_ally4 = ally4s
		GC.skills.append(GC.ally4.skill1)
		GC.skills.append(GC.ally4.skill2)
		GC.skills.append(GC.ally4.skill3)
		GC.skills.append(GC.ally4.skill4)
	if GC.enemy1 != null:
		var enemy1s = ENEMY.instantiate()
		enemy1 = enemy1s
		enemy1s.res = GC.enemy1
		enemy_1_spot.add_child(enemy1s)
		combat_manager.enemy1 = enemy1s
		GC.combat_enemy1 = enemy1s
	if GC.enemy2 != null:
		var enemy2s = ENEMY.instantiate()
		enemy2 = enemy2s
		enemy2s.res = GC.enemy2
		enemy_2_spot.add_child(enemy2s)
		combat_manager.enemy2 = enemy2s
		GC.combat_enemy2 = enemy2s
	if GC.enemy3 != null:
		var enemy3s = ENEMY.instantiate()
		enemy3 = enemy3s
		enemy3s.res = GC.enemy3
		enemy_3_spot.add_child(enemy3s)
		combat_manager.enemy3 = enemy3s
		GC.combat_enemy3 = enemy3s
	if GC.enemy4 != null:
		var enemy4s = ENEMY.instantiate()
		enemy4 = enemy4s
		enemy4s.res = GC.enemy4
		enemy_4_spot.add_child(enemy4s)
		combat_manager.enemy4 = enemy4s
		GC.combat_enemy4 = enemy4s
	GC.update_combat_lists()
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
	for ally in allies:
		ally.update_vars()
	if (GC.relics != null):
		# loads relics
		var new_relic_handler = RELIC_HANDLER.instantiate()
		relic_handler_spot.add_child(new_relic_handler)
		for relic in GC.relics:
			new_relic_handler.add_relic(relic)
		combat_manager.relics = new_relic_handler
		
	for skill in GC.skills:
		if skill == null:
			GC.skills.erase(skill)

	
func toggle_relic_tooltip():
	relic_info.visible = !relic_info.visible


func _on_reaction_guide_pressed() -> void:
	if reaction_panel.visible:
		reaction_panel.visible = false
		GC.reaction_guide_open = false
		end_turn.visible = true
		#for enemy in enemies:
			#enemy.show_next_skill_info()
		#for ally in allies:
			#ally.spell_select_ui.visible = true
	elif not reaction_panel.visible:
		reaction_panel.visible = true
		GC.reaction_guide_open = true
		end_turn.visible = false
		#for enemy in enemies:
			#enemy.hide_next_skill_info()
		#for ally in allies:
			#ally.spell_select_ui.visible = false


func _on_win_pressed() -> void:
	combat_manager.victory()
