extends Node2D
@onready var progress_bar: ProgressBar = $ProgressBar
var hp = 100
var curr_elem = ""
@onready var label: Label = $Label
@onready var timer: Timer = $Label/Timer
@onready var currelem: Label = $currelem
var delayed_multiplier = 1
var delayed_countdown = 0
var delay = false
@onready var damage_num: Label = $DamageNum
@onready var d_timer: Timer = $DamageNum/dTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progress_bar.max_value = hp
	progress_bar.value = hp

func calc_damage(damage, element):
	var multiplier = 1
	var totaldmg = 0
	match reaction(element):
		"vaporize":
			popup("Vaporize!")
			currelem.text = "current element: nothing"
			multiplier = 2
		"shock":
			popup("shocked!")
			currelem.text = "current element: nothing"
			delayed_multiplier = 1.5
			delayed_countdown = 3
			delay = true
		_:
			curr_elem = element
			currelem.text = "current element: " + element
			
	
	if (delay):
		if (delayed_countdown > 0):
			delayed_countdown -= 1
			if (delayed_countdown == 0):
				totaldmg = (damage * multiplier * delayed_multiplier)
				delay = false
			else:
				totaldmg = (damage * multiplier)
	else:
		totaldmg = (damage * multiplier)
	
	hp -= totaldmg
	progress_bar.value = hp
	dpopup(str(totaldmg) + "!")
			
		
		

func reaction(elem):
	if (curr_elem == "fire"):
		match elem:
			"water":
				return "vaporize"
	if (curr_elem == "water"):
		match elem:
			"lightning":
				return "shock"
	

func _on_fire_pressed() -> void:
	calc_damage(10, "fire")

func _on_water_pressed() -> void:
	calc_damage(10, "water")


func _on_lightning_pressed() -> void:
	calc_damage(10, "lightning")

func _on_earth_pressed() -> void:
	calc_damage(10, "earth")

func popup(text):
	label.visible = true
	label.text = text
	timer.start()
	
func dpopup(text):
	damage_num.visible = true
	damage_num.text = text
	d_timer.start()

func _on_timer_timeout() -> void:
	label.visible = false


func _on_d_timer_timeout() -> void:
	damage_num.visible = false
