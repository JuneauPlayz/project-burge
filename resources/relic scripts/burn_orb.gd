extends Relic

var member_var = 0

func initialize_relic(owner : RelicUI) -> void:
	GC.burn_damage += 10
	GC.burn_length += 1
	
func get_tooltip() -> String:
	return tooltip
