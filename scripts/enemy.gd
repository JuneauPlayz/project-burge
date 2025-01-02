extends Unit
class_name Enemy

@export var skill : Skill
@export var current_element : String = "none"
@export var reaction_primed = 0
var hp_bar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#always make hp bar second child
	print(health)
	hp_bar = get_child(1)
	hp_bar.set_hp(health)
	hp_bar.set_maxhp(health)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func take_element(element: String):
	if current_element == "none":
		current_element = element
	else:
		#naive implementation, will eventually need access to a dictionary
		#of reactions or something
		if current_element == element:
			pass
		else:
			reaction_primed = 1
			print("reaction primed")
			current_element = "none"



func take_damage(damage: float):
	var rounded: int
	if reaction_primed == 1:
		damage = (damage * 2)
		print("reaction activated")
		reaction_primed = 0
	rounded = roundi(damage)
	health -= rounded
	hp_bar.set_hp(health)
	check_if_dead()


func check_if_dead():
	if health <= 0:
		die()

func die():
	print("ded")
