extends Node

# mults
var vaporize_mult = 2
var shock_mult = 0.25
var erupt_mult = 3
var detonate_main_mult = 1.5
var detonate_side_mult = 0.5



signal reaction_finished


var BUBBLE = preload("res://resources/Status Effects/Bubble.tres")


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
					reaction = " Vaporize!"
					if hostile == 1:
						DamageNumbers.display_number(unit.take_damage(res_value * hostile), unit.get_child(2).global_position, elem2, reaction)
					unit.current_element = "none"
					GC.vaporize()
				"lightning":
					res_value = roundi(value)
					reaction = " Detonate!"
					DamageNumbers.display_number(unit.take_damage(res_value * detonate_main_mult), unit.get_child(2).global_position, elem2, reaction)
					if (unit.hasLeft() or unit.hasRight()):
						await get_tree().create_timer(0.2).timeout
					if (unit.hasLeft()):
						DamageNumbers.display_number(unit.left.take_damage(res_value * detonate_side_mult), unit.left.get_child(2).global_position, elem2, "")
					if (unit.hasRight()):
						DamageNumbers.display_number(unit.right.take_damage(res_value * detonate_side_mult), unit.right.get_child(2).global_position, elem2, "")
					unit.current_element = "none"
					GC.detonate()
				"earth":
					res_value = roundi(value)
					GC.erupt()
					if (unit.shield > 0):
						var shield = unit.shield
						#if shield wont break
						if ((value * erupt_mult) < shield):
							unit.take_damage(value * erupt_mult)
							res_value = value * erupt_mult
							reaction = " Erupted!" 
						else:
							var shield_dmg = (shield + erupt_mult-1) / erupt_mult
							value -= shield_dmg
							res_value = value + shield
							unit.take_damage(res_value)
							reaction = " Erupted!"
					else:
						unit.take_damage(res_value * hostile)
					if hostile == 1:
						DamageNumbers.display_number(res_value, unit.get_child(2).global_position, elem2, reaction)
					unit.current_element = "none"
				"grass":
					reaction = " Burn!"
					if hostile == 1:
						DamageNumbers.display_number(unit.take_damage(roundi(value * hostile)), unit.get_child(2).global_position, elem2, reaction)
					unit.current_element = "none"
					GC.burn()
		# water reactions
		"water":
			match elem2:
				"fire":
					res_value = roundi(value * vaporize_mult)
					reaction = " Vaporize!"
					if hostile == 1:
						DamageNumbers.display_number(unit.take_damage(res_value * hostile), unit.get_child(2).global_position, elem2, reaction)
					unit.current_element = "none"
					GC.vaporize()
				"lightning":
					reaction = " Shock!"
					res_value = roundi(value * shock_mult)
					if hostile == 1:
						DamageNumbers.display_number(unit.take_damage(roundi(value * hostile)), unit.get_child(2).global_position, elem2, reaction)
						await get_tree().create_timer(0.2).timeout
						DamageNumbers.display_number(unit.take_damage(res_value), unit.get_child(2).global_position, elem2, reaction)
						await get_tree().create_timer(0.2).timeout
						DamageNumbers.display_number(unit.take_damage(res_value), unit.get_child(2).global_position, elem2, reaction)
						await get_tree().create_timer(0.2).timeout
						DamageNumbers.display_number(unit.take_damage(res_value), unit.get_child(2).global_position, elem2, reaction)
					unit.current_element = "lightning"
					GC.shock()
				"earth":
					if hostile == 1:
						DamageNumbers.display_number(unit.take_damage(roundi(value * hostile)), unit.get_child(2).global_position, elem2, reaction)
					unit.current_element = "none"
				"grass":
					reaction = " Bloom!"
					if hostile == 1:
						DamageNumbers.display_number(unit.take_damage(roundi(value * hostile)), unit.get_child(2).global_position, elem2, reaction)
					unit.current_element = "none"
					GC.bloom()
		"lightning":
			match elem2:
				"fire":
					res_value = roundi(value)
					reaction = " Detonate!"
					DamageNumbers.display_number(unit.take_damage(res_value * detonate_main_mult), unit.get_child(2).global_position, elem2, reaction)
					if (unit.hasLeft() or unit.hasRight()):
						await get_tree().create_timer(0.2).timeout
					if (unit.hasLeft()):
						DamageNumbers.display_number(unit.left.take_damage(res_value * detonate_side_mult), unit.left.get_child(2).global_position, elem2, "")
					if (unit.hasRight()):
						DamageNumbers.display_number(unit.right.take_damage(res_value * detonate_side_mult), unit.right.get_child(2).global_position, elem2, "")
					unit.current_element = "none"
					GC.detonate()
				"water":
					reaction = " Shock!"
					res_value = roundi(value * shock_mult)
					if hostile == 1:
						DamageNumbers.display_number(unit.take_damage(roundi(value * hostile)), unit.get_child(2).global_position, elem2, reaction)
						await get_tree().create_timer(0.2).timeout
						DamageNumbers.display_number(unit.take_damage(res_value), unit.get_child(2).global_position, elem2, reaction)
						await get_tree().create_timer(0.2).timeout
						DamageNumbers.display_number(unit.take_damage(res_value), unit.get_child(2).global_position, elem2, reaction)
						await get_tree().create_timer(0.2).timeout
						DamageNumbers.display_number(unit.take_damage(res_value), unit.get_child(2).global_position, elem2, reaction)
					unit.current_element = "lightning"
					GC.shock()
				"earth":
					if hostile == 1:
						DamageNumbers.display_number(unit.take_damage(res_value * hostile), unit.get_child(2).global_position, elem2, reaction)
					unit.current_element = "none"
				"grass":
					reaction = " Nitro!"
					if hostile == 1:
						DamageNumbers.display_number(unit.take_damage(res_value * hostile), unit.get_child(2).global_position, elem2, reaction)
					unit.current_element = "none"
					GC.nitro()
					
		"earth":
			match elem2:
				"earth":
					if hostile == 1:
						DamageNumbers.display_number(unit.take_damage(res_value * hostile), unit.get_child(2).global_position, elem2, reaction)
					unit.current_element = "none"
				"fire":
					res_value = roundi(value)
					GC.erupt()
					if (unit.shield > 0):
						var shield = unit.shield
						#if shield wont break
						if ((value * erupt_mult) < shield):
							unit.take_damage(value * erupt_mult)
							res_value = value * erupt_mult
							reaction = " Erupted!"
						else:
							var shield_dmg = (shield + erupt_mult-1) / erupt_mult
							value -= shield_dmg
							res_value = value + shield
							unit.take_damage(res_value)
							reaction = " Erupted!!"
					else:
						unit.take_damage(res_value * hostile)
					if hostile == 1:
						DamageNumbers.display_number(res_value, unit.get_child(2).global_position, elem2, reaction)
					unit.current_element = "none"
				"water":
					if hostile == 1:
						DamageNumbers.display_number(unit.take_damage(roundi(value * hostile)), unit.get_child(2).global_position, elem2, reaction)
					unit.current_element = "none"
				"lightning":
					if hostile == 1:
						DamageNumbers.display_number(unit.take_damage(roundi(value * hostile)), unit.get_child(2).global_position, elem2, reaction)
					unit.current_element = "none"
				"grass":
					var bubble_effect = BUBBLE.duplicate()
					DamageNumbers.display_text(unit.get_child(2).global_position, "grass", "Bubbled!")
					unit.status.append(bubble_effect)
					unit.bubbled = true
					unit.current_element = "none"
		"grass":
			match elem2:
				"grass":
					if hostile == 1:
						DamageNumbers.display_number(unit.take_damage(roundi(value * hostile)), unit.get_child(2).global_position, elem2, reaction)
					unit.current_element = "none"
				"earth":
					var bubble_effect = BUBBLE.duplicate()
					DamageNumbers.display_text(unit.get_child(2).global_position, "grass", "Bubbled!")
					unit.status.append(bubble_effect)
					unit.bubbled = true
					unit.current_element = "none"
				"fire":
					reaction = " Burn!"
					if hostile == 1:
						DamageNumbers.display_number(unit.take_damage(roundi(value * hostile)), unit.get_child(2).global_position, elem2, reaction)
					unit.current_element = "none"
					GC.burn()
				"water":
					reaction = " Bloom!"
					if hostile == 1:
						DamageNumbers.display_number(unit.take_damage(roundi(value * hostile)), unit.get_child(2).global_position, elem2, reaction)
					unit.current_element = "none"
					GC.bloom()
				"lightning":
					reaction = " Nitro!"
					if hostile == 1:
						DamageNumbers.display_number(unit.take_damage(roundi(value * hostile)), unit.get_child(2).global_position, elem2, reaction)
					unit.current_element = "none"
					GC.nitro()
			
	reaction_finished.emit()				
	return true
					
		
