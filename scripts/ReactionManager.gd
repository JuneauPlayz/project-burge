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

func reaction(elem1: String, elem2: String, unit: Unit, value, friendly: bool, caster: Unit) -> bool:
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
					if caster is Ally:
						GC.vaporize()
				"lightning":
					detonate(elem1, elem2, unit, value, friendly)
					if caster is Ally:
						GC.detonate()
				"earth":
					erupt(elem1, elem2, unit, value, friendly)
					if caster is Ally:
						GC.erupt()
				"grass":
					burn(elem1, elem2, unit, value, friendly)
					if caster is Ally:
						GC.burn()
		"water":
			match elem2:
				"fire":
					vaporize(elem1, elem2, unit, value, friendly)
					if caster is Ally:
						GC.vaporize()
				"lightning":
					shock(elem1, elem2, unit, value, friendly)
					if caster is Ally:
						GC.shock()
				"earth":
					muck(elem1, elem2, unit, value, friendly)
					if caster is Ally:
						GC.muck()
				"grass":
					bloom(elem1, elem2, unit, value, friendly)
					if caster is Ally:
						GC.bloom()
		"lightning":
			match elem2:
				"fire":
					detonate(elem1, elem2, unit, value, friendly)
					if caster is Ally:
						GC.detonate()
				"water":
					shock(elem1, elem2, unit, value, friendly)
					if caster is Ally:
						GC.shock()
				"earth":
					discharge(elem1, elem2, unit, value, friendly)
					if caster is Ally:
						GC.discharge()
				"grass":
					nitro(elem1, elem2, unit, value, friendly)
					if caster is Ally:
						GC.nitro()
		"earth":
			match elem2:
				"fire":
					erupt(elem1, elem2, unit, value, friendly)
					if caster is Ally:
						GC.erupt()
				"water":
					muck(elem1, elem2, unit, value, friendly)
					if caster is Ally:
						GC.muck()
				"lightning":
					discharge(elem1, elem2, unit, value, friendly)
					if caster is Ally:
						GC.discharge()
				"grass":
					sow(elem1, elem2, unit, value, friendly)
					if caster is Ally:
						GC.sow()
		"grass":
			match elem2:
				"earth":
					sow(elem1, elem2, unit, value, friendly)
					if caster is Ally:
						GC.sow()
				"fire":
					burn(elem1, elem2, unit, value, friendly)
					if caster is Ally:
						GC.burn()
				"water":
					bloom(elem1, elem2, unit, value, friendly)
					if caster is Ally:
						GC.bloom()
				"lightning":
					nitro(elem1, elem2, unit, value, friendly)
					if caster is Ally:
						GC.nitro()
	return true

func vaporize(elem1: String, elem2: String, unit: Unit, value, friendly: bool) -> void:
	var reaction_name = " Vaporize!"
	var res_value = roundi(value * GC.vaporize_mult)
	unit.current_element = "none"
	DamageNumbers.display_text(unit.damage_number_origin.global_position, elem2, reaction_name, 38)
	if not friendly:
		unit.take_damage(res_value, elem2, false)
	await get_tree().create_timer(0.01).timeout
	reaction_finished.emit()

func detonate(elem1: String, elem2: String, unit: Unit, value, friendly: bool) -> void:
	var reaction_name = " Detonate!"
	var res_value = roundi(value)
	unit.current_element = "none"
	if unit == null:
		return
	DamageNumbers.display_text(unit.damage_number_origin.global_position, elem2, reaction_name, 38)
	if unit.hasLeft() or unit.hasRight():
		await get_tree().create_timer(0.2).timeout
	if unit.hasLeft():
		unit.left.take_damage(res_value * GC.detonate_side_mult, elem2, true)
	if unit.hasRight():
		unit.right.take_damage(res_value * GC.detonate_side_mult, elem2, true)
	if not friendly:
		unit.take_damage(res_value * GC.detonate_main_mult, elem2, false)
	await get_tree().create_timer(0.01).timeout
	reaction_finished.emit()

func erupt(elem1: String, elem2: String, unit: Unit, value, friendly: bool) -> void:
	var reaction_name = " Erupted!"
	var res_value = roundi(value)
	unit.current_element = "none"
	DamageNumbers.display_text(unit.damage_number_origin.global_position, elem2, reaction_name, 38)
	if not friendly:
		if unit.shield > 0:
			var shield = unit.shield
			if (value * GC.erupt_mult) < shield:
				unit.take_damage(value * GC.erupt_mult, elem2, false)
				res_value = value * GC.erupt_mult
			else:
				var shield_dmg = (shield + GC.erupt_mult - 1) / GC.erupt_mult
				value -= shield_dmg
				res_value = value + shield
				unit.take_damage(res_value, elem2, false)
				reaction_name = " Erupted!!"
		else:
			unit.take_damage(res_value, elem2, false)
	elif friendly:
		unit.receive_shielding(value, elem2, false)
	await get_tree().create_timer(0.01).timeout
	reaction_finished.emit()

func burn(elem1: String, elem2: String, unit: Unit, value, friendly: bool) -> void:
	var reaction_name = " Burn!"
	var new_burn = BURN.duplicate()
	new_burn.turns_remaining = GC.burn_length
	new_burn.damage = GC.burn_damage
	unit.current_element = "none"
	unit.status.append(new_burn)
	unit.hp_bar.update_statuses(unit.status)
	DamageNumbers.display_text(unit.damage_number_origin.global_position, elem2, reaction_name, 38)
	if not friendly:
		unit.take_damage(roundi(value), elem2, false)
	elif friendly:
		unit.receive_healing(roundi(value), elem2, false)
	await get_tree().create_timer(0.01).timeout
	reaction_finished.emit()

func shock(elem1: String, elem2: String, unit: Unit, value, friendly: bool) -> void:
	var reaction_name = " Shock!"
	var res_value = roundi(value * GC.shock_mult)
	unit.current_element = "none"
	DamageNumbers.display_text(unit.damage_number_origin.global_position, elem2, reaction_name, 38)
	if not friendly:
		unit.take_damage(roundi(value), elem2, false)
		await get_tree().create_timer(0.2).timeout
		if unit != null:
			unit.take_damage(res_value, "lightning", true)
			DamageNumbers.display_text(unit.damage_number_origin.global_position, elem2, reaction_name, 38)
		await get_tree().create_timer(0.2).timeout
		if unit != null:
			unit.take_damage(res_value, "lightning", true)
			DamageNumbers.display_text(unit.damage_number_origin.global_position, elem2, reaction_name, 38)
			await get_tree().create_timer(0.2).timeout
		if unit != null:
			unit.take_damage(res_value, "lightning", true)
		DamageNumbers.display_text(unit.damage_number_origin.global_position, elem2, reaction_name, 38)
	await get_tree().create_timer(0.01).timeout
	reaction_finished.emit()

func bloom(elem1: String, elem2: String, unit: Unit, value, friendly: bool) -> void:
	var reaction_name = " Bloom!"
	var bubble_effect = BUBBLE.duplicate()
	unit.status.append(bubble_effect)
	unit.hp_bar.update_statuses(unit.status)
	unit.current_element = "none"
	DamageNumbers.display_text(unit.damage_number_origin.global_position, elem2, reaction_name, 38)
	if not friendly:
		unit.take_damage(roundi(value), elem2, false)
	elif friendly:
		unit.receive_healing(roundi(value), elem2, false)
	await get_tree().create_timer(0.01).timeout
	reaction_finished.emit()

func nitro(elem1: String, elem2: String, unit: Unit, value, friendly: bool) -> void:
	var reaction_name = " Nitro!"
	var nitro_effect = NITRO.duplicate()
	unit.status.append(nitro_effect)
	unit.hp_bar.update_statuses(unit.status)
	unit.current_element = "none"
	DamageNumbers.display_text(unit.damage_number_origin.global_position, elem2, reaction_name, 38)
	if not friendly:
		unit.take_damage(roundi(value), elem2, false)
	elif friendly:
		unit.receive_healing(roundi(value), elem2, false)
	await get_tree().create_timer(0.01).timeout
	reaction_finished.emit()

func discharge(elem1: String, elem2: String, unit: Unit, value, friendly: bool) -> void:
	var reaction_name = " Discharge!"
	var split_damage = value
	if GC.combat_enemies.size() > 0:
		split_damage = roundi((value * GC.discharge_mult) / GC.combat_enemies.size())
		unit.current_element = "none"
	DamageNumbers.display_text(unit.damage_number_origin.global_position, elem2, reaction_name, 38)
	if not friendly:
		unit.take_damage(roundi(split_damage), elem2, false)
	elif friendly:
		unit.receive_shielding(roundi(value), elem2, false)
	for enemy in GC.combat_enemies:
		if enemy != null and enemy != unit:
			enemy.take_damage(roundi(split_damage), "none", true)
	reaction_finished.emit()

func sow(elem1: String, elem2: String, unit: Unit, value, friendly: bool) -> void:
	var reaction_name = " Sow!"
	var sow_effect = SOW.duplicate()
	unit.status.append(sow_effect)
	unit.hp_bar.update_statuses(unit.status)
	unit.current_element = "none"
	DamageNumbers.display_text(unit.damage_number_origin.global_position, elem2, reaction_name, 38)
	if not friendly:
		unit.take_damage(roundi(value), elem2, false)
	elif friendly and elem2 == "grass":
		unit.receive_healing(roundi(value), elem2, false)
	elif friendly and elem2 == "earth":
		unit.receive_shielding(roundi(value), elem2, false)
	await get_tree().create_timer(0.01).timeout
	reaction_finished.emit()

func muck(elem1: String, elem2: String, unit: Unit, value, friendly: bool) -> void:
	var reaction_name = " Muck!"
	var muck_effect = MUCK.duplicate()
	unit.status.append(muck_effect)
	unit.hp_bar.update_statuses(unit.status)
	unit.current_element = "none"
	DamageNumbers.display_text(unit.damage_number_origin.global_position, elem2, reaction_name, 38)
	if not friendly:
		unit.take_damage(roundi(value), elem2, false)
	elif friendly and elem2 == "earth":
		unit.receive_shielding(roundi(value), elem2, false)
	await get_tree().create_timer(0.01).timeout
	reaction_finished.emit()
