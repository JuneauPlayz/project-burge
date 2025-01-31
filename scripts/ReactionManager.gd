extends Node

signal reaction_finished

const BLEED = preload("res://resources/Status Effects/Bleed.tres")
const BUBBLE = preload("res://resources/Status Effects/Bubble.tres")
const BURN = preload("res://resources/Status Effects/Burn.tres")
const MUCK = preload("res://resources/Status Effects/Muck.tres")
const NITRO = preload("res://resources/Status Effects/Nitro.tres")
const SOW = preload("res://resources/Status Effects/Sow.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func reaction(elem1: String, elem2: String, unit: Unit, value, friendly : bool) -> bool:
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
					vaporize(elem1, elem2, unit, value, friendly)
				"lightning":
					detonate(elem1, elem2, unit, value, friendly)
				"earth":
					erupt(elem1, elem2, unit, value, friendly)
				"grass":
					burn(elem1, elem2, unit, value, friendly)
		"water":
			match elem2:
				"fire":
					vaporize(elem1, elem2, unit, value, friendly)
				"lightning":
					shock(elem1, elem2, unit, value, friendly)
				"earth":
					muck(elem1, elem2, unit, value, friendly)
				"grass":
					bloom(elem1, elem2, unit, value, friendly)
		"lightning":
			match elem2:
				"fire":
					detonate(elem1, elem2, unit, value, friendly)
				"water":
					shock(elem1, elem2, unit, value, friendly)
				"earth":
					discharge(elem1, elem2, unit, value, friendly)
				"grass":
					nitro(elem1, elem2, unit, value, friendly)
		"earth":
			match elem2:
				"fire":
					erupt(elem1, elem2, unit, value, friendly)
				"water":
					muck(elem1, elem2, unit, value, friendly)
				"lightning":
					discharge(elem1, elem2, unit, value, friendly)
				"grass":
					sow(elem1, elem2, unit, value, friendly)
		"grass":
			match elem2:
				"earth":
					sow(elem1, elem2, unit, value, friendly)
				"fire":
					burn(elem1, elem2, unit, value, friendly)
				"water":
					bloom(elem1, elem2, unit, value, friendly)
				"lightning":
					nitro(elem1, elem2, unit, value, friendly)
	return true

func vaporize(elem1: String, elem2: String, unit: Unit, value, friendly: bool) -> void:
	var reaction_name = " Vaporize!"
	var res_value = roundi(value * GC.vaporize_mult)
	unit.current_element = "none"
	GC.vaporize()
	if not friendly:
		DamageNumbers.display_number(unit.take_damage(res_value), unit.get_child(2).global_position, elem2, reaction_name)
	await get_tree().create_timer(0.01).timeout
	reaction_finished.emit()

func detonate(elem1: String, elem2: String, unit: Unit, value, friendly: bool) -> void:
	var reaction_name = " Detonate!"
	var res_value = roundi(value)
	unit.current_element = "none"
	GC.detonate()
	if not friendly:
		DamageNumbers.display_number(unit.take_damage(res_value * GC.detonate_main_mult), unit.get_child(2).global_position, elem2, reaction_name)
	if unit == null:
		return
	if unit.hasLeft() or unit.hasRight():
		await get_tree().create_timer(0.2).timeout
	if unit.hasLeft():
		DamageNumbers.display_number(unit.left.take_damage(res_value * GC.detonate_side_mult), unit.left.get_child(2).global_position, elem2, "")
	if unit.hasRight():
		DamageNumbers.display_number(unit.right.take_damage(res_value * GC.detonate_side_mult), unit.right.get_child(2).global_position, elem2, "")
	await get_tree().create_timer(0.01).timeout
	reaction_finished.emit()

func erupt(elem1: String, elem2: String, unit: Unit, value, friendly: bool) -> void:
	var reaction_name = " Erupted!"
	var res_value = roundi(value)
	unit.current_element = "none"
	GC.erupt()
	if not friendly:
		if unit.shield > 0:
			var shield = unit.shield
			if (value * GC.erupt_mult) < shield:
				DamageNumbers.display_number(unit.take_damage(value * GC.erupt_mult), unit.get_child(2).global_position, elem2, reaction_name)
				res_value = value * GC.erupt_mult
			else:
				var shield_dmg = (shield + GC.erupt_mult - 1) / GC.erupt_mult
				value -= shield_dmg
				res_value = value + shield
				DamageNumbers.display_number(unit.take_damage(res_value), unit.get_child(2).global_position, elem2, reaction_name)
				reaction_name = " Erupted!!"
		else:
			DamageNumbers.display_number(unit.take_damage(res_value), unit.get_child(2).global_position, elem2, reaction_name)
	await get_tree().create_timer(0.01).timeout
	reaction_finished.emit()

func burn(elem1: String, elem2: String, unit: Unit, value, friendly: bool) -> void:
	var reaction_name = " Burn!"
	var new_burn = BURN.duplicate()
	new_burn.turns_remaining = GC.burn_length
	new_burn.damage = GC.burn_damage
	unit.status.append(new_burn)
	unit.hp_bar.update_statuses(unit.status)
	unit.current_element = "none"
	GC.burn()
	if not friendly:
		DamageNumbers.display_number(unit.take_damage(roundi(value)), unit.get_child(2).global_position, elem2, reaction_name)
	elif friendly:
		DamageNumbers.display_number_plus(unit.receive_healing(roundi(value)), unit.get_child(2).global_position, elem2, reaction_name)
	await get_tree().create_timer(0.01).timeout
	reaction_finished.emit()

func shock(elem1: String, elem2: String, unit: Unit, value, friendly: bool) -> void:
	var reaction_name = " Shock!"
	var res_value = roundi(value * GC.shock_mult)
	unit.current_element = "lightning"
	GC.shock()
	if not friendly:
		DamageNumbers.display_number(unit.take_damage(roundi(value)), unit.get_child(2).global_position, elem2, reaction_name)
		await get_tree().create_timer(0.2).timeout
		if unit != null:
			DamageNumbers.display_number(unit.take_damage(res_value), unit.get_child(2).global_position, elem2, reaction_name)
		await get_tree().create_timer(0.2).timeout
		if unit != null:
			DamageNumbers.display_number(unit.take_damage(res_value), unit.get_child(2).global_position, elem2, reaction_name)
			await get_tree().create_timer(0.2).timeout
		if unit != null:
			DamageNumbers.display_number(unit.take_damage(res_value), unit.get_child(2).global_position, elem2, reaction_name)
	await get_tree().create_timer(0.01).timeout
	reaction_finished.emit()

func bloom(elem1: String, elem2: String, unit: Unit, value, friendly: bool) -> void:
	var reaction_name = " Bloom!"
	var bubble_effect = BUBBLE.duplicate()
	unit.status.append(bubble_effect)
	unit.hp_bar.update_statuses(unit.status)
	unit.current_element = "none"
	GC.bloom()
	if not friendly:
		DamageNumbers.display_number(unit.take_damage(roundi(value)), unit.get_child(2).global_position, elem2, reaction_name)
	elif friendly:
		DamageNumbers.display_number_plus(unit.receive_healing(roundi(value)), unit.get_child(2).global_position, elem2, reaction_name)
	DamageNumbers.display_text(unit.get_child(2).global_position, "grass", "Bubbled!", 32)
	await get_tree().create_timer(0.01).timeout
	reaction_finished.emit()

func nitro(elem1: String, elem2: String, unit: Unit, value, friendly: bool) -> void:
	var reaction_name = " Nitro!"
	var nitro_effect = NITRO.duplicate()
	unit.status.append(nitro_effect)
	unit.hp_bar.update_statuses(unit.status)
	unit.current_element = "none"
	GC.nitro()
	if not friendly:
		DamageNumbers.display_number(unit.take_damage(roundi(value)), unit.get_child(2).global_position, elem2, reaction_name)
	elif friendly:
		DamageNumbers.display_number_plus(unit.receive_healing(roundi(value)), unit.get_child(2).global_position, elem2, reaction_name)
	DamageNumbers.display_text(unit.get_child(2).global_position, "lightning", reaction_name, 32)
	await get_tree().create_timer(0.01).timeout
	reaction_finished.emit()

func discharge(elem1: String, elem2: String, unit: Unit, value, friendly: bool) -> void:
	var reaction_name = " Discharge!"
	var split_damage = roundi((value * GC.discharge_mult) / 4)
	unit.current_element = "none"
	GC.discharge()
	if not friendly:
		DamageNumbers.display_number(unit.take_damage(roundi(value)), unit.get_child(2).global_position, elem2, reaction_name)
	elif friendly:
		DamageNumbers.display_number_plus(unit.receive_shielding(roundi(value)), unit.get_child(2).global_position, elem2, reaction_name)
	for enemy in GC.combat_enemies:
		if enemy != null and enemy != unit:
			DamageNumbers.display_number_size(enemy.take_damage(roundi(split_damage)), enemy.get_child(2).global_position, "none", reaction_name, 36)
	reaction_finished.emit()

func sow(elem1: String, elem2: String, unit: Unit, value, friendly: bool) -> void:
	var reaction_name = " Sow!"
	var sow_effect = SOW.duplicate()
	unit.status.append(sow_effect)
	unit.hp_bar.update_statuses(unit.status)
	unit.current_element = "none"
	GC.sow()
	if not friendly:
		DamageNumbers.display_number(unit.take_damage(roundi(value)), unit.get_child(2).global_position, elem2, reaction_name)
	elif friendly and elem2 == "grass":
		DamageNumbers.display_number_plus(unit.receive_healing(roundi(value)), unit.get_child(2).global_position, elem2, reaction_name)
	elif friendly and elem2 == "earth":
		DamageNumbers.display_number_plus(unit.receive_shielding(roundi(value)), unit.get_child(2).global_position, elem2, reaction_name)
	DamageNumbers.display_text(unit.get_child(2).global_position, "earth", reaction_name, 32)
	await get_tree().create_timer(0.01).timeout
	reaction_finished.emit()

func muck(elem1: String, elem2: String, unit: Unit, value, friendly: bool) -> void:
	var reaction_name = " Muck!"
	var muck_effect = MUCK.duplicate()
	unit.status.append(muck_effect)
	unit.hp_bar.update_statuses(unit.status)
	unit.current_element = "none"
	GC.muck()
	if not friendly:
		DamageNumbers.display_number(unit.take_damage(roundi(value)), unit.get_child(2).global_position, elem2, reaction_name)
	elif friendly and elem2 == "earth":
		DamageNumbers.display_number_plus(unit.receive_shielding(roundi(value)), unit.get_child(2).global_position, elem2, reaction_name)
	DamageNumbers.display_text(unit.get_child(2).global_position, "earth", reaction_name, 32)
	await get_tree().create_timer(0.01).timeout
	reaction_finished.emit()

func no_reaction(elem1: String, elem2: String, unit: Unit, value, friendly: bool) -> void:
	reaction_finished.emit()
