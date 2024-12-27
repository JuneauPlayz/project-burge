extends Node2D
@onready var progress_bar: ProgressBar = $ProgressBar
var hp = 100
var curr_elem = ""
@onready var label: Label = $Label
@onready var timer: Timer = $Label/Timer
@onready var currelem: Label = $currelem


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progress_bar.max_value = hp
	progress_bar.value = hp

func calc_damage(damage, element):
	var multiplier = 1
	match reaction(element):
		"vaporize":
			popup("Vaporize!")
			currelem.text = "current element: nothing"
			multiplier = 2
		_:
			curr_elem = element
			currelem.text = "current element: " + element
			
	hp -= (damage * multiplier)
	progress_bar.value = hp

			
		
		

func reaction(elem):
	if (curr_elem == "fire"):
		match elem:
			"water":
				return "vaporize"
	

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
	


func _on_timer_timeout() -> void:
	label.visible = false
