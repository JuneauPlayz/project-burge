extends Relic

var member_var = 0
@export var damage_amount : int

func activate_relic(owner: RelicUI) -> void:
	var combat = owner.get_tree().get_first_node_in_group("combat")
	if combat:
		for enemy in combat.enemies:
			if (enemy != null or enemy.visible == true):
				enemy.take_damage(damage_amount)
				DamageNumbers.display_number(damage_amount, enemy.damage_number_origin.global_position, "none", "")
