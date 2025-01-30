extends Node

signal reaction_finished

var BUBBLE = preload("res://resources/Status Effects/Bubble.tres")
const BURN = preload("res://resources/Status Effects/Burn.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func reaction(elem1: String, elem2: String, unit: Unit, value, hostile: int) -> bool:
	var res_value = value
	
	# if unit is dead
	if unit == null:
		return false
	
	if elem1 == "none" or elem2 == "none":
		reaction_finished.emit()
		return false
	
	if elem1 == elem2:
		reaction_finished.emit()
		return false
	
	match elem1:
		"fire":
			match elem2:
				"water":
					vaporize(elem1, elem2, unit, value, hostile)
				"lightning":
					detonate(elem1, elem2, unit, value, hostile)
				"earth":
					erupt(elem1, elem2, unit, value, hostile)
				"grass":
					burn(elem1, elem2, unit, value, hostile)
		"water":
			match elem2:
				"fire":
					vaporize(elem1, elem2, unit, value, hostile)
				"lightning":
					shock(elem1, elem2, unit, value, hostile)
				"earth":
					no_reaction(elem1, elem2, unit, value, hostile)
				"grass":
					bloom(elem1, elem2, unit, value, hostile)
		"lightning":
			match elem2:
				"fire":
					detonate(elem1, elem2, unit, value, hostile)
				"water":
					shock(elem1, elem2, unit, value, hostile)
				"earth":
					discharge(elem1, elem2, unit, value, hostile)
				"grass":
					nitro(elem1, elem2, unit, value, hostile)
		"earth":
			match elem2:
				"fire":
					erupt(elem1, elem2, unit, value, hostile)
				"water":
					no_reaction(elem1, elem2, unit, value, hostile)
				"lightning":
					discharge(elem1, elem2, unit, value, hostile)
				"grass":
					bubble(elem1, elem2, unit, value, hostile)
		"grass":
			match elem2:
				"earth":
					bubble(elem1, elem2, unit, value, hostile)
				"fire":
					burn(elem1, elem2, unit, value, hostile)
				"water":
					bloom(elem1, elem2, unit, value, hostile)
				"lightning":
					nitro(elem1, elem2, unit, value, hostile)
	return true

func vaporize(elem1: String, elem2: String, unit: Unit, value, hostile: int) -> void:
	var reaction_name = " Vaporize!"
	var res_value = roundi(value * GC.vaporize_mult)
	if hostile == 1:
		DamageNumbers.display_number(unit.take_damage(res_value * hostile), unit.get_child(2).global_position, elem2, reaction_name)
	unit.current_element = "none"
	GC.vaporize()
	reaction_finished.emit()

func detonate(elem1: String, elem2: String, unit: Unit, value, hostile: int) -> void:
	var reaction_name = " Detonate!"
	var res_value = roundi(value)
	DamageNumbers.display_number(unit.take_damage(res_value * GC.detonate_main_mult), unit.get_child(2).global_position, elem2, reaction_name)
	if unit == null:
		return
	if unit.hasLeft() or unit.hasRight():
		await get_tree().create_timer(0.2).timeout
	if unit.hasLeft():
		DamageNumbers.display_number(unit.left.take_damage(res_value * GC.detonate_side_mult), unit.left.get_child(2).global_position, elem2, "")
	if unit.hasRight():
		DamageNumbers.display_number(unit.right.take_damage(res_value * GC.detonate_side_mult), unit.right.get_child(2).global_position, elem2, "")
	unit.current_element = "none"
	GC.detonate()
	reaction_finished.emit()

func erupt(elem1: String, elem2: String, unit: Unit, value, hostile: int) -> void:
	var reaction_name = " Erupted!"
	var res_value = roundi(value)
	GC.erupt()
	if unit.shield > 0:
		var shield = unit.shield
		if (value * GC.erupt_mult) < shield:
			unit.take_damage(value * GC.erupt_mult)
			res_value = value * GC.erupt_mult
		else:
			var shield_dmg = (shield + GC.erupt_mult - 1) / GC.erupt_mult
			value -= shield_dmg
			res_value = value + shield
			unit.take_damage(res_value)
			reaction_name = " Erupted!!"
	else:
		unit.take_damage(res_value * hostile)
	if hostile == 1:
		DamageNumbers.display_number(res_value, unit.get_child(2).global_position, elem2, reaction_name)
	unit.current_element = "none"
	reaction_finished.emit()

func burn(elem1: String, elem2: String, unit: Unit, value, hostile: int) -> void:
	var reaction_name = " Burn!"
	var new_burn = BURN.duplicate()
	new_burn.turns_remaining = GC.burn_length
	new_burn.damage = GC.burn_damage
	unit.status.append(new_burn)
	if hostile == 1:
		DamageNumbers.display_number(unit.take_damage(roundi(value * hostile)), unit.get_child(2).global_position, elem2, reaction_name)
	unit.current_element = "none"
	GC.burn()
	reaction_finished.emit()

func shock(elem1: String, elem2: String, unit: Unit, value, hostile: int) -> void:
	var reaction_name = " Shock!"
	var res_value = roundi(value * GC.shock_mult)
	if hostile == 1:
		DamageNumbers.display_number(unit.take_damage(roundi(value * hostile)), unit.get_child(2).global_position, elem2, reaction_name)
		await get_tree().create_timer(0.2).timeout
		DamageNumbers.display_number(unit.take_damage(res_value), unit.get_child(2).global_position, elem2, reaction_name)
		await get_tree().create_timer(0.2).timeout
		DamageNumbers.display_number(unit.take_damage(res_value), unit.get_child(2).global_position, elem2, reaction_name)
		await get_tree().create_timer(0.2).timeout
		DamageNumbers.display_number(unit.take_damage(res_value), unit.get_child(2).global_position, elem2, reaction_name)
	unit.current_element = "lightning"
	GC.shock()
	reaction_finished.emit()

func bloom(elem1: String, elem2: String, unit: Unit, value, hostile: int) -> void:
	var reaction_name = " Bloom!"
	if hostile == 1:
		DamageNumbers.display_number(unit.take_damage(roundi(value * hostile)), unit.get_child(2).global_position, elem2, reaction_name)
	unit.current_element = "none"
	if unit is Enemy:
		for ally in GC.combat_allies:
			if ally != null:
				ally.receive_healing(GC.ally_bloom_healing * GC.bloom_mult)
				DamageNumbers.display_number_plus(GC.ally_bloom_healing * GC.bloom_mult, ally.damage_number_origin.global_position, "grass", "")
	elif unit is Ally:
		for enemy in GC.combat_enemies:
			if enemy != null:
				enemy.receive_healing(GC.enemy_bloom_healing)
				DamageNumbers.display_number_plus(GC.enemy_bloom_healing, enemy.damage_number_origin.global_position, "grass", "")
	GC.bloom()
	reaction_finished.emit()

func nitro(elem1: String, elem2: String, unit: Unit, value, hostile: int) -> void:
	var reaction_name = " Nitro!"
	if hostile == 1:
		DamageNumbers.display_number(unit.take_damage(roundi(value * hostile)), unit.get_child(2).global_position, elem2, reaction_name)
	unit.current_element = "none"
	GC.nitro()
	reaction_finished.emit()

func discharge(elem1: String, elem2: String, unit: Unit, value, hostile: int) -> void:
	var reaction_name = " Discharge!"
	var split_damage = roundi((value * GC.discharge_mult) / 4)
	unit.current_element = "none"
	GC.discharge()
	DamageNumbers.display_number(unit.take_damage(roundi(split_damage)), unit.get_child(2).global_position, elem2, reaction_name)
	for enemy in GC.combat_enemies:
		if enemy != null and enemy != unit:
			DamageNumbers.display_number_size(enemy.take_damage(roundi(split_damage)), enemy.get_child(2).global_position, "none", reaction_name, 36)
	reaction_finished.emit()
	
func bubble(elem1: String, elem2: String, unit: Unit, value, hostile: int) -> void:
	var reaction_name = " Bubbled!"
	var bubble_effect = BUBBLE.duplicate()
	DamageNumbers.display_text(unit.get_child(2).global_position, "grass", reaction_name)
	unit.status.append(bubble_effect)
	unit.bubbled = true
	unit.current_element = "none"
	reaction_finished.emit()

func no_reaction(elem1: String, elem2: String, unit: Unit, value, hostile: int) -> void:
	reaction_finished.emit()
	pass
