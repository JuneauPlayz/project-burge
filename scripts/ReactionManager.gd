extends Node

var vaporize_mult = 2
var shock_mult = 0.25
signal reaction_finished
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func reaction(elem1 : String, elem2 : String, unit : Unit, value, hostile : int):
	var reaction = ""
	var res_value = value
	if (elem1 == "none" or elem2 == "none"): 
		reaction_finished.emit()
		return false
	if (elem1 == elem2):
		reaction_finished.emit()
		return false
	match elem1:
		# fire reactions
		"fire":
			match elem2:
				"water":
					res_value = roundi(value * vaporize_mult)
					unit.take_damage(res_value * hostile)
					reaction = " Vaporize!"
					if hostile == 1:
						DamageNumbers.display_number(res_value, unit.get_child(2).global_position, elem2, reaction)
					unit.current_element = "none"
				"lightning":
					res_value = roundi(value)
					unit.take_damage(res_value * hostile)
					reaction = " Detonate!"
					if hostile == 1:
						DamageNumbers.display_number(res_value, unit.get_child(2).global_position, elem2, reaction)
					unit.current_element = "none"
				"earth":
					unit.current_element = "none"
					res_value = roundi(value)
					unit.take_damage(res_value * hostile)
					if hostile == 1:
						DamageNumbers.display_number(res_value, unit.get_child(2).global_position, elem2, reaction)
					unit.current_element = "none"
		# water reactions
		"water":
			match elem2:
				"fire":
					res_value = roundi(value * vaporize_mult)
					unit.take_damage(res_value * hostile)
					reaction = " Vaporize!"
					if hostile == 1:
						DamageNumbers.display_number(res_value, unit.get_child(2).global_position, elem2, reaction)
					unit.current_element = "none"
				"lightning":
					reaction = " Shock!"
					res_value = roundi(value * shock_mult)
					unit.take_damage(roundi(value * hostile))
					if hostile == 1:
						DamageNumbers.display_number(roundi(value), unit.get_child(2).global_position, elem2, reaction)
						await get_tree().create_timer(0.2).timeout
						unit.take_damage(res_value)
						DamageNumbers.display_number(res_value, unit.get_child(2).global_position, elem2, reaction)
						await get_tree().create_timer(0.2).timeout
						unit.take_damage(res_value)
						DamageNumbers.display_number(res_value, unit.get_child(2).global_position, elem2, reaction)
						await get_tree().create_timer(0.2).timeout
						unit.take_damage(res_value)
						DamageNumbers.display_number(res_value, unit.get_child(2).global_position, elem2, reaction)
					unit.current_element = "lightning"
				"earth":
					unit.take_damage(roundi(value * hostile))
					if hostile == 1:
						DamageNumbers.display_number(res_value, unit.get_child(2).global_position, elem2, reaction)
					unit.current_element = "none"
		"lightning":
			match elem2:
				"fire":
					res_value = roundi(value)
					unit.take_damage(res_value * hostile)
					reaction = " Detonate!"
					if hostile == 1:
						DamageNumbers.display_number(res_value, unit.get_child(2).global_position, elem2, reaction)
					unit.current_element = "none"
				"water":
					reaction = " Shock!"
					res_value = roundi(value * shock_mult)
					unit.take_damage(roundi(value * hostile))
					if hostile == 1:
						DamageNumbers.display_number(roundi(value), unit.get_child(2).global_position, elem2, reaction)
						await get_tree().create_timer(0.2).timeout
						unit.take_damage(res_value)
						DamageNumbers.display_number(res_value, unit.get_child(2).global_position, elem2, reaction)
						await get_tree().create_timer(0.2).timeout
						unit.take_damage(res_value)
						DamageNumbers.display_number(res_value, unit.get_child(2).global_position, elem2, reaction)
						await get_tree().create_timer(0.2).timeout
						unit.take_damage(res_value)
						DamageNumbers.display_number(res_value, unit.get_child(2).global_position, elem2, reaction)
					unit.current_element = "lightning"
				"earth":
					unit.take_damage(roundi(value * hostile))
					if hostile == 1:
						DamageNumbers.display_number(res_value, unit.get_child(2).global_position, elem2, reaction)
					unit.current_element = "none"
		"earth":
			match elem2:
				"earth":
					unit.take_damage(roundi(value * hostile))
					if hostile == 1:
						DamageNumbers.display_number(res_value, unit.get_child(2).global_position, elem2, reaction)
					unit.current_element = "none"
				"fire":
					unit.take_damage(roundi(value * hostile))
					if hostile == 1:
						DamageNumbers.display_number(res_value, unit.get_child(2).global_position, elem2, reaction)
					unit.current_element = "none"
				"water":
					unit.take_damage(roundi(value * hostile))
					if hostile == 1:
						DamageNumbers.display_number(res_value, unit.get_child(2).global_position, elem2, reaction)
					unit.current_element = "none"
				"lightning":
					unit.take_damage(roundi(value * hostile))
					if hostile == 1:
						DamageNumbers.display_number(res_value, unit.get_child(2).global_position, elem2, reaction)
					unit.current_element = "none"
	reaction_finished.emit()				
	return true
					
		
