extends Relic

var member_var = 0

func initialize_relic(owner : RelicUI) -> void:
	GC.detonate_main_mult += 0.5
	GC.detonate_side_mult += 0.25
	
func activate_relic(owner: RelicUI) -> void:
	print("this happens at specific times based on the Relic.Type property")
	
func deactivate_relic(owner: RelicUI) -> void:
	print("this gets called when a RelicUI is exiting hte SceneTree")

func get_tooltip() -> String:
	return tooltip
