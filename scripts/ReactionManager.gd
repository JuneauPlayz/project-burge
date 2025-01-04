extends Node

var vaporize_mult = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func reaction(elem1 : String, elem2 : String, unit : Unit, value):
	var reaction = ""
	var res_value = value
	if (elem1 == "none" or elem2 == "none"): 
		return false
	if (elem1 == elem2):
		return false
	match elem1:
		# fire reactions
		"fire":
			match elem2:
				"water":
					res_value = roundi(value * vaporize_mult)
					unit.take_damage(res_value)
					reaction = " Vaporize!"
					DamageNumbers.display_number(res_value, unit.get_child(2).global_position, elem2, reaction)
					unit.current_element = "none"
		# water reactions
		"water":
			match elem2:
				"fire":
					res_value = roundi(value * vaporize_mult)
					unit.take_damage(res_value)
					reaction = " Vaporize!"
					DamageNumbers.display_number(res_value, unit.get_child(2).global_position, elem2, reaction)
					unit.current_element = "none"
	return true
					
		
