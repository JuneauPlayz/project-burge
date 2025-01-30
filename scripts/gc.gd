extends Node

var is_dragging = false

const GLOBAL_INTERVAL = 0.15
# global currencies
var gold = 50
var bonus_gold = 0
var gold_multiplier = 1
#combat
const FIRE_POTION = preload("res://scenes/relic handler/relics/fire_potion.tres")
const SHIELD_POTION = preload("res://scenes/relic handler/relics/shield_potion.tres")
const VAPOR_ORB = preload("res://scenes/relic handler/relics/vapor_orb.tres")


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
var obtainable_relics = [FIRE_POTION, SHIELD_POTION, VAPOR_ORB]

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
	self.ally1 = ally1
	self.ally2 = ally2
	self.ally3 = ally3
	self.ally4 = ally4
	self.enemy1 = enemy1
	self.enemy2 = enemy2
	self.enemy3 = enemy3
	self.enemy4 = enemy4
	
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
	gold += (count + bonus_gold + gold_multiplier)
	
func reset():
	gold = 0
	self.ally1 = null
	self.ally2 = null
	self.ally3 = null
	self.ally4 = null
	self.enemy1 = null
	self.enemy2 = null
	self.enemy3 = null
	self.enemy4 = null
	reset_tokens()
	relics = []
	
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
