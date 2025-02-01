extends Node

var is_dragging = false

const GLOBAL_INTERVAL = 0.15
# global currencies
var gold = 0
var bonus_gold = 0
var gold_multiplier = 1
#combat
var current_reward = 10
const FIRE_POTION = preload("res://resources/relics/fire_potion.tres")
const SHIELD_POTION = preload("res://resources/relics/shield_potion.tres")
const VAPOR_ORB = preload("res://resources/relics/vapor_orb.tres")
const CHILL_GUY = preload("res://resources/units/enemies/ChillGuy.tres")

const TEAM_MAGMA_GRUNT = preload("res://resources/units/enemies/TeamMagmaGrunt.tres")

# predetermined fights

var fight_1 = [TEAM_MAGMA_GRUNT, TEAM_MAGMA_GRUNT, CHILL_GUY, null]
var fight_1_reward = 10

var fight_2 = [CHILL_GUY, TEAM_MAGMA_GRUNT, null, null]
var fight_2_reward = 15

var fight_3 = [CHILL_GUY, CHILL_GUY, CHILL_GUY, CHILL_GUY]
var fight_3_reward = 20

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

# event based relics
var ghostfire = false
var flow = false

func _ready():
	current_fight = fight_1
	var dir = DirAccess.open("res://resources/relics")
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		var RELIC = load("res://resources/relics/" + file_name)
		GC.obtainable_relics.append(RELIC)
		file_name = dir.get_next()
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
		dir.list_dir_begin()
		file_name = dir.get_next()
		while file_name != "":
			var SKILL = load("res://resources/Skills/" + element + "/" + file_name)
			if SKILL.purchaseable == true:
				GC.obtainable_skills.append(SKILL)
			file_name = dir.get_next()
	for relic in GC.obtainable_relics:
		print(relic.relic_name)
		
func next_fight():
	match current_fight:
		fight_1:
			current_fight = fight_2
			current_reward = fight_2_reward
		fight_2:
			current_fight = fight_3
			current_reward = fight_3_reward
		fight_3:
			get_tree().quit()
	
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
	
	
func load_combat(ally1, ally2, ally3, ally4, enemy1, enemy2, enemy3, enemy4, reward):
	self.ally1 = ally1
	self.ally2 = ally2
	self.ally3 = ally3
	self.ally4 = ally4
	self.enemy1 = enemy1
	self.enemy2 = enemy2
	self.enemy3 = enemy3
	self.enemy4 = enemy4
	current_reward = reward
	
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
	
	ghostfire = false
	flow = false
	# Reset combat-related variables
	current_reward = 10
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

	# Reset unit resources
	ally1 = null
	ally2 = null
	ally3 = null
	ally4 = null
	enemy1 = null
	enemy2 = null
	enemy3 = null
	enemy4 = null

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
