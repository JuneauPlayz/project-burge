extends Node

var is_dragging = false

const GLOBAL_INTERVAL = 0.15
# global currencies
var gold = 0
var bonus_gold = 0
var gold_multiplier = 1
#combat
var current_reward = 6
const FIRE_POTION = preload("res://resources/relics/fire_potion.tres")
const SHIELD_POTION = preload("res://resources/relics/shield_potion.tres")
const VAPOR_ORB = preload("res://resources/relics/vapor_orb.tres")
const CHILL_GUY = preload("res://resources/units/enemies/ChillGuy.tres")
const PYROMANCER = preload("res://resources/units/enemies/pyromancer.tres")
const TEAM_MAGMA_GRUNT = preload("res://resources/units/enemies/TeamMagmaGrunt.tres")
const HYDROMANCER = preload("res://resources/units/enemies/hydromancer.tres")
const BAGUETTE = preload("res://resources/units/enemies/Baguette.tres")
const ORB_WIZARD = preload("res://resources/units/enemies/OrbWizard.tres")
const LIGHTNING_MASTER = preload("res://resources/units/enemies/LightningMaster.tres")
const THEFINALBOSS = preload("res://resources/units/enemies/THEFINALBOSS.tres")

# predetermined fights

var fight_1 = [TEAM_MAGMA_GRUNT, CHILL_GUY, null, null]
var fight_1_reward = 6

var fight_2 = [CHILL_GUY, TEAM_MAGMA_GRUNT, BAGUETTE, null]
var fight_2_reward = 6

var fight_3 = [PYROMANCER, HYDROMANCER, null, null]
var fight_3_reward = 9

var fight_4 = [CHILL_GUY, LIGHTNING_MASTER, BAGUETTE, ORB_WIZARD]
var fight_4_reward = 12

var fight_5 = [PYROMANCER, HYDROMANCER, LIGHTNING_MASTER, ORB_WIZARD]
var fight_5_reward = 15

var fight_6 = [null, null, THEFINALBOSS, null]
var fight_6_reward = 18

var current_fight = fight_1
#loading unit reses
var ally1 : UnitRes
var ally2 : UnitRes
var ally3 : UnitRes
var ally4 : UnitRes

var enemy1 : UnitRes
var enemy2 : UnitRes
var enemy3 : UnitRes
var enemy4 : UnitRes

var og_ally_1_skill1 : Skill
var og_ally_1_skill2 : Skill
var og_ally_2_skill1 : Skill
var og_ally_2_skill2 : Skill
var og_ally_3_skill1 : Skill
var og_ally_3_skill2 : Skill
var og_ally_4_skill1 : Skill
var og_ally_4_skill2 : Skill

var og_enemy_1_skill1 : Skill
var og_enemy_1_skill2 : Skill
var og_enemy_2_skill1 : Skill
var og_enemy_2_skill2 : Skill
var og_enemy_3_skill1 : Skill
var og_enemy_3_skill2 : Skill
var og_enemy_4_skill1 : Skill
var og_enemy_4_skill2 : Skill

var ally1level = 0
var ally1levelup = false
var ally2level = 0
var ally2levelup = false
var ally3level = 0
var ally3levelup = false
var ally4level = 0
var ally4levelup = false

var relics = []
var obtainable_relics = []

var skills = []
var obtainable_skills = []
# units in combat
var combat_ally1 : Ally
var combat_ally2 : Ally
var combat_ally3 : Ally
var combat_ally4 : Ally

var combat_enemy1 : Enemy
var combat_enemy2 : Enemy
var combat_enemy3 : Enemy
var combat_enemy4 : Enemy

var combat_allies = []
var combat_enemies = []

#tokens
var fire_tokens = 0
var water_tokens = 0
var lightning_tokens = 0
var grass_tokens = 1
var earth_tokens = 0

var fire_token_multiplier = 1
var water_token_multiplier = 1
var lightning_token_multiplier = 1
var	grass_token_multiplier = 1
var earth_token_multiplier = 1

var fire_token_bonus = 0
var water_token_bonus = 0
var lightning_token_bonus = 0
var grass_token_bonus = 0
var earth_token_bonus = 0

#mults
var vaporize_mult = 2
var shock_mult = 0.25
var erupt_mult = 3
var detonate_main_mult = 1.5
var detonate_side_mult = 0.5
var bloom_mult = 1
var nitro_mult = 1.5
var bubble_mult = 0.5
var burn_damage = 10
var burn_length = 2
var muck_mult = 0.75
var discharge_mult = 1
var sow_shielding = 5
var sow_healing = 5
var sow_healing_mult = 1
var sow_shielding_mult = 1

var ally_bloom_healing = 5
var enemy_bloom_healing = 5

# token bonus and mults

# Vaporize (Fire + Water)
var vaporize_fire_token_base = 1
var vaporize_water_token_base = 1
var vaporize_fire_token_mult = 1
var vaporize_water_token_mult = 1
var vaporize_fire_token_bonus = 0
var vaporize_water_token_bonus = 0

# Detonate (Fire + Lightning)
var detonate_fire_token_base = 1
var detonate_lightning_token_base = 1
var detonate_fire_token_mult = 1
var detonate_lightning_token_mult = 1
var detonate_fire_token_bonus = 0
var detonate_lightning_token_bonus = 0

# Erupt (Fire + Earth)
var erupt_fire_token_base = 1
var erupt_earth_token_base = 1
var erupt_fire_token_mult = 1
var erupt_earth_token_mult = 1
var erupt_fire_token_bonus = 0
var erupt_earth_token_bonus = 0

# Burn (Fire + Grass)
var burn_fire_token_base = 1
var burn_grass_token_base = 1
var burn_fire_token_mult = 1
var burn_grass_token_mult = 1
var burn_fire_token_bonus = 0
var burn_grass_token_bonus = 0

# Shock (Water + Lightning)
var shock_water_token_base = 1
var shock_lightning_token_base = 1
var shock_water_token_mult = 1
var shock_lightning_token_mult = 1
var shock_water_token_bonus = 0
var shock_lightning_token_bonus = 0

# Bloom (Water + Grass)
var bloom_water_token_base = 1
var bloom_grass_token_base = 1
var bloom_water_token_mult = 1
var bloom_grass_token_mult = 1
var bloom_water_token_bonus = 0
var bloom_grass_token_bonus = 0

# Nitro (Lightning + Grass)
var nitro_lightning_token_base = 1
var nitro_grass_token_base = 1
var nitro_lightning_token_mult = 1
var nitro_grass_token_mult = 1
var nitro_lightning_token_bonus = 0
var nitro_grass_token_bonus = 0

# Muck (Water + Earth)
var muck_water_token_base = 1
var muck_earth_token_base = 1
var muck_water_token_mult = 1
var muck_earth_token_mult = 1
var muck_water_token_bonus = 0
var muck_earth_token_bonus = 0

# Discharge (Earth + Lightning)
var discharge_earth_token_base = 1
var discharge_lightning_token_base = 1
var discharge_earth_token_mult = 1
var discharge_lightning_token_mult = 1
var discharge_earth_token_bonus = 0
var discharge_lightning_token_bonus = 0

# Sow (Earth + Grass)
var sow_earth_token_base = 1
var sow_grass_token_base = 1
var sow_earth_token_mult = 1
var sow_grass_token_mult = 1
var sow_earth_token_bonus = 0
var sow_grass_token_bonus = 0

var disable_level_up = false
var end = false
# event based relics
var ghostfire = false
var flow = false
var lightning_strikes_twice = false

func _ready():
	current_fight = fight_1
	var dir = DirAccess.open("res://resources/relics")
	var relics = []
	get_all_files_from_directory("res://resources/relics", "", relics)
	for filename in relics:
		var relic = load(filename)
		GC.obtainable_relics.append(relic)
	var element = ""
	for i in range(1,6):
		match i:
			1:
				element = "fire"
			2:
				element = "water"
			3:
				element = "lightning"
			4:
				element = "grass"
			5:
				element = "earth"
			6:
				element = "physical"
		dir = DirAccess.open("res://resources/Skills/" + element)
		var skills = []
		get_all_files_from_directory("res://resources/Skills/" + element, "", skills)
		for filename in skills:
			var skill = load(filename)
			if skill.purchaseable == true:
				GC.obtainable_skills.append(skill)
		
func get_all_files_from_directory(path : String, file_ext:= "", files := []):
	var resources = ResourceLoader.list_directory(path)
	for res in resources:
		print(str(path+res))
		if res.ends_with("/"): 
			get_all_files_from_directory(path+res, file_ext, files)
		files.append(path+"/"+res)
	return files
	
func next_fight():
	match current_fight:
		fight_1:
			current_fight = fight_2
			current_reward = fight_2_reward
		fight_2:
			current_fight = fight_3
			current_reward = fight_3_reward
			level_up_allies()
		fight_3:
			current_fight = fight_4
			current_reward = fight_4_reward
			disable_level_ups()
		fight_4:
			current_fight = fight_5
			current_reward = fight_5_reward
			level_up_allies()
		fight_5:
			current_fight = fight_6
			current_reward = fight_6_reward
			end = true
		fight_6:
			end_game()

func end_game():
	get_tree().change_scene_to_file("res://scenes/main scenes/ending_screen.tscn")

func level_up_allies():
	disable_level_up = false
	print("hiaaaaaaaaaaaaaaaaaaaaaaa")
	if ally1 != null:
		ally1level += 1
		ally1levelup = true
		ally1.level = ally1level
		ally1.level_up = ally1levelup
	if ally2 != null:
		ally2level += 1
		ally2levelup = true
		ally2.level = ally2level
		ally2.level_up = ally2levelup
	if ally3 != null:
		ally3level += 1
		ally3levelup = true
		ally3.level = ally3level
		ally3.level_up = ally3levelup
	if ally4 != null:
		ally4level += 1
		ally4levelup = true
		ally4.level = ally4level
		ally4.level_up = ally4levelup
		
func disable_level_ups():
	if GC.ally1 != null:
		ally1levelup = false
	if GC.ally2 != null:
		ally2levelup = false
	if GC.ally3 != null:
		ally3levelup = false
	if GC.ally4 != null:
		ally4levelup = false

	
func get_random_relic():
	if GC.obtainable_relics == []:
		return null
	var rng = RandomNumberGenerator.new()
	var random_num = rng.randi_range(0,obtainable_relics.size()-1)
	var relic = obtainable_relics[random_num]
	while relic in GC.relics:
		random_num = rng.randi_range(0,obtainable_relics.size()-1)
		relic = obtainable_relics[random_num]
	return relic
	
func get_random_skill():
	var rng = RandomNumberGenerator.new()
	var random_num = rng.randi_range(0,obtainable_skills.size()-1)
	var skill = obtainable_skills[random_num]
	while skill in GC.skills:
		random_num = rng.randi_range(0,obtainable_skills.size()-1)
		skill = obtainable_skills[random_num]
	return skill
	
func vaporize():
	add_token("fire", (GC.vaporize_fire_token_base + GC.vaporize_fire_token_bonus) * GC.vaporize_fire_token_mult)
	add_token("water", (GC.vaporize_water_token_base + GC.vaporize_water_token_bonus) * GC.vaporize_water_token_mult)

func shock():
	add_token("lightning", (GC.shock_lightning_token_base + GC.shock_lightning_token_bonus) * GC.shock_lightning_token_mult)
	add_token("water", (GC.shock_water_token_base + GC.shock_water_token_bonus) * GC.shock_water_token_mult)

func detonate():
	add_token("fire", (GC.detonate_fire_token_base + GC.detonate_fire_token_bonus) * GC.detonate_fire_token_mult)
	add_token("lightning", (GC.detonate_lightning_token_base + GC.detonate_lightning_token_bonus) * GC.detonate_lightning_token_mult)

func erupt():
	add_token("fire", (GC.erupt_fire_token_base + GC.erupt_fire_token_bonus) * GC.erupt_fire_token_mult)
	add_token("earth", (GC.erupt_earth_token_base + GC.erupt_earth_token_bonus) * GC.erupt_earth_token_mult)

func bloom():
	add_token("water", (GC.bloom_water_token_base + GC.bloom_water_token_bonus) * GC.bloom_water_token_mult)
	add_token("grass", (GC.bloom_grass_token_base + GC.bloom_grass_token_bonus) * GC.bloom_grass_token_mult)

func burn():
	add_token("fire", (GC.burn_fire_token_base + GC.burn_fire_token_bonus) * GC.burn_fire_token_mult)
	add_token("grass", (GC.burn_grass_token_base + GC.burn_grass_token_bonus) * GC.burn_grass_token_mult)

func nitro():
	add_token("grass", (GC.nitro_grass_token_base + GC.nitro_grass_token_bonus) * GC.nitro_grass_token_mult)
	add_token("lightning", (GC.nitro_lightning_token_base + GC.nitro_lightning_token_bonus) * GC.nitro_lightning_token_mult)
	
func muck():
	add_token("water", (GC.muck_water_token_base + GC.muck_water_token_bonus) * GC.muck_water_token_mult)
	add_token("earth", (GC.muck_earth_token_base + GC.muck_earth_token_bonus) * GC.muck_earth_token_mult)

func discharge():
	add_token("earth", (GC.discharge_earth_token_base + GC.discharge_earth_token_bonus) * GC.discharge_earth_token_mult)
	add_token("lightning", (GC.discharge_lightning_token_base + GC.discharge_lightning_token_bonus) * GC.discharge_lightning_token_mult)

func sow():
	add_token("earth", (GC.sow_earth_token_base + GC.sow_earth_token_bonus) * GC.sow_earth_token_mult)
	add_token("grass", (GC.sow_grass_token_base + GC.sow_grass_token_bonus) * GC.sow_grass_token_mult)

func reset_tokens():
	fire_tokens = 0
	water_tokens = 0
	lightning_tokens = 0
	grass_tokens = 0
	earth_tokens = 0
	
	
func load_combat(ally1, ally2, ally3, ally4, enemy1, enemy2, enemy3, enemy4):
	self.enemy1 = null
	self.enemy2 = null
	self.enemy3 = null
	self.enemy4 = null
	if ally1:
		self.ally1 = ally1.duplicate()
		self.ally1.level = ally1level
		self.ally1.level_up = ally1levelup
	if ally2:
		self.ally2 = ally2.duplicate()
		self.ally2.level = ally2level
		self.ally2.level_up = ally2levelup
	if ally3:
		self.ally3 = ally3.duplicate()
		self.ally3.level = ally3level
		self.ally3.level_up = ally3levelup
	if ally4:
		self.ally4 = ally4.duplicate()
		self.ally4.level = ally4level
		self.ally4.level_up = ally4levelup
	if enemy1:
		self.enemy1 = enemy1.duplicate()
	if enemy2:
		self.enemy2 = enemy2.duplicate()
	if enemy3:
		self.enemy3 = enemy3.duplicate()
	if enemy4:
		self.enemy4 = enemy4.duplicate()

	
func add_token(element, count):
	match element:
		"fire":
			fire_tokens += ((count + fire_token_bonus) * fire_token_multiplier)
		"water":
			water_tokens += ((count + water_token_bonus) * water_token_multiplier)
		"lightning":
			lightning_tokens += ((count + lightning_token_bonus) * lightning_token_multiplier)
		"grass":
			grass_tokens += ((count + grass_token_bonus) * grass_token_multiplier)
		"earth":
			earth_tokens += ((count + earth_token_bonus) * earth_token_multiplier)
			
func add_gold(count):
	gold += ((count + bonus_gold) * gold_multiplier)
	
func reset():
	# Reset global currencies
	gold = 0
	bonus_gold = 0
	gold_multiplier = 1

	# Reset event-based relics
	ghostfire = false
	flow = false
	lightning_strikes_twice = false

	# Reset combat-related variables
	current_reward = 3
	combat_ally1 = null
	combat_ally2 = null
	combat_ally3 = null
	combat_ally4 = null
	combat_enemy1 = null
	combat_enemy2 = null
	combat_enemy3 = null
	combat_enemy4 = null
	combat_allies = []
	combat_enemies = []

	# Reset relics and skills
	relics = []
	obtainable_relics = []
	skills = []
	obtainable_skills = []

	# Reset tokens
	reset_tokens()
	fire_token_multiplier = 1
	water_token_multiplier = 1
	lightning_token_multiplier = 1
	grass_token_multiplier = 1
	earth_token_multiplier = 1
	fire_token_bonus = 0
	water_token_bonus = 0
	lightning_token_bonus = 0
	grass_token_bonus = 0
	earth_token_bonus = 0

	# Reset reaction multipliers and bonuses
	vaporize_mult = 2
	shock_mult = 0.25
	erupt_mult = 3
	detonate_main_mult = 1.5
	detonate_side_mult = 0.5
	bloom_mult = 1
	nitro_mult = 1.5
	bubble_mult = 0.5
	burn_damage = 10
	burn_length = 2
	muck_mult = 0.75
	discharge_mult = 1
	sow_shielding = 5
	sow_healing = 5
	sow_healing_mult = 1
	sow_shielding_mult = 1
	ally_bloom_healing = 5
	enemy_bloom_healing = 5

	# Reset token base, mult, and bonus for each reaction
	# Vaporize (Fire + Water)
	vaporize_fire_token_base = 1
	vaporize_water_token_base = 1
	vaporize_fire_token_mult = 1
	vaporize_water_token_mult = 1
	vaporize_fire_token_bonus = 0
	vaporize_water_token_bonus = 0

	# Detonate (Fire + Lightning)
	detonate_fire_token_base = 1
	detonate_lightning_token_base = 1
	detonate_fire_token_mult = 1
	detonate_lightning_token_mult = 1
	detonate_fire_token_bonus = 0
	detonate_lightning_token_bonus = 0

	# Erupt (Fire + Earth)
	erupt_fire_token_base = 1
	erupt_earth_token_base = 1
	erupt_fire_token_mult = 1
	erupt_earth_token_mult = 1
	erupt_fire_token_bonus = 0
	erupt_earth_token_bonus = 0

	# Burn (Fire + Grass)
	burn_fire_token_base = 1
	burn_grass_token_base = 1
	burn_fire_token_mult = 1
	burn_grass_token_mult = 1
	burn_fire_token_bonus = 0
	burn_grass_token_bonus = 0

	# Shock (Water + Lightning)
	shock_water_token_base = 1
	shock_lightning_token_base = 1
	shock_water_token_mult = 1
	shock_lightning_token_mult = 1
	shock_water_token_bonus = 0
	shock_lightning_token_bonus = 0

	# Bloom (Water + Grass)
	bloom_water_token_base = 1
	bloom_grass_token_base = 1
	bloom_water_token_mult = 1
	bloom_grass_token_mult = 1
	bloom_water_token_bonus = 0
	bloom_grass_token_bonus = 0

	# Nitro (Lightning + Grass)
	nitro_lightning_token_base = 1
	nitro_grass_token_base = 1
	nitro_lightning_token_mult = 1
	nitro_grass_token_mult = 1
	nitro_lightning_token_bonus = 0
	nitro_grass_token_bonus = 0

	# Muck (Water + Earth)
	muck_water_token_base = 1
	muck_earth_token_base = 1
	muck_water_token_mult = 1
	muck_earth_token_mult = 1
	muck_water_token_bonus = 0
	muck_earth_token_bonus = 0

	# Discharge (Earth + Lightning)
	discharge_earth_token_base = 1
	discharge_lightning_token_base = 1
	discharge_earth_token_mult = 1
	discharge_lightning_token_mult = 1
	discharge_earth_token_bonus = 0
	discharge_lightning_token_bonus = 0

	# Sow (Earth + Grass)
	sow_earth_token_base = 1
	sow_grass_token_base = 1
	sow_earth_token_mult = 1
	sow_grass_token_mult = 1
	sow_earth_token_bonus = 0
	sow_grass_token_bonus = 0

	# Restore original skills for allies and enemies
	
		
	# Reset unit resources
	ally1 = null
	ally2 = null
	ally3 = null
	ally4 = null
	enemy1 = null
	enemy2 = null
	enemy3 = null
	enemy4 = null
	
	end = false
	_ready()
	
func update_combat_lists():
	combat_allies = []
	combat_allies.append(combat_ally1)
	combat_allies.append(combat_ally2)
	combat_allies.append(combat_ally3)
	combat_allies.append(combat_ally4)
	combat_enemies = []
	combat_enemies.append(combat_enemy1)
	combat_enemies.append(combat_enemy2)
	combat_enemies.append(combat_enemy3)
	combat_enemies.append(combat_enemy4)
