extends Node

var is_dragging = false

#combat

var ally1 = null
var ally2 = null
var ally3 = null
var ally4 = null
var enemy1 = null
var enemy2 = null
var enemy3 = null
var enemy4 = null

func load_combat(ally1, ally2, ally3, ally4, enemy1, enemy2, enemy3, enemy4):
	self.ally1 = ally1
	self.ally2 = ally2
	self.ally3 = ally3
	self.ally4 = ally4
	self.enemy1 = enemy1
	self.enemy2 = enemy2
	self.enemy3 = enemy3
	self.enemy4 = enemy4
	
	
