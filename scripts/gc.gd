extends Node

var is_dragging = false

#combat

#units
var ally1 = null
var ally2 = null
var ally3 = null
var ally4 = null
var enemy1 = null
var enemy2 = null
var enemy3 = null
var enemy4 = null

#tokens
var fire_tokens = 0
var water_tokens = 0
var lightning_tokens = 0
var nature_tokens = 0
var earth_tokens = 0

var fire_token_multiplier = 1
var water_token_multiplier = 1
var lightning_token_multiplier = 1
var	nature_token_multiplier = 1
var earth_token_multiplier = 1

func vaporize():
	add_token("fire", 1)
	add_token("water", 1)
	
func shock():
	add_token("lightning", 1)
	add_token("water", 1)


func reset_tokens():
	fire_tokens = 0
	water_tokens = 0
	lightning_tokens = 0
	nature_tokens = 0
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
			fire_tokens += (count * fire_token_multiplier)
		"water":
			water_tokens += (count * water_token_multiplier)
		"lightning":
			lightning_tokens += (count * lightning_token_multiplier)
		"nature":
			nature_tokens += (count * nature_token_multiplier)
		"earth":
			earth_tokens += (count * earth_token_multiplier)
			
	
