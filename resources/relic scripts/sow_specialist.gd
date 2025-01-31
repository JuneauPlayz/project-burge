extends Relic

var member_var = 0

func initialize_relic(owner : RelicUI) -> void:
	GC.sow_shielding += 10
	GC.sow_healing += 10
	
func get_tooltip() -> String:
	return tooltip
