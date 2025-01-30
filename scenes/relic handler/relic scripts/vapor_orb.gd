extends Relic

var member_var = 0

func initialize_relic(owner : RelicUI) -> void:
	GC.vaporize_mult += 0.5
	GC.vaporize_fire_token_bonus += 1
	
func get_tooltip() -> String:
	return tooltip
