extends Unit
class_name Enemy

@export var skill : Skill
@export var current_element : String = "none"
@export var reaction_primed = 0
@onready var damage_number_origin: Node2D = $DamageNumberOrigin
@onready var current_element_text: Label = $CurrentElement


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
	

func take_damage(damage: float, element: String):
	var rounded : int
	var reaction = ""
	if current_element == "none":
		current_element = element
	else:
		#naive implementation, will eventually need access to a dictionary
		#of reactions or something
		if current_element == element:
			pass
		else:
			print("reaction activated")
			reaction = " Vaporize!"
			damage = (damage * 2)
			current_element = "none"
	rounded = roundi(damage)
	health -= rounded
	hp_bar.set_hp(health)
	current_element_text.text = "Current Element: " + current_element
	check_if_dead()

	DamageNumbers.display_number(rounded, damage_number_origin.global_position, element, reaction)

func check_if_dead():
	if health <= 0:
		die()

func die():
	print("ded")
