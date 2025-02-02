extends Relic

var member_var = 0
@export var healing_amount : int

	
func activate_relic(owner: RelicUI) -> void:
	var combat = owner.get_tree().get_first_node_in_group("combat")
	if combat:
		for ally in combat.allies:
			if ally != null:
				ally.receive_healing(healing_amount)
	
func get_tooltip() -> String:
	return tooltip
