extends Relic

var member_var = 0

func initialize_relic(owner : RelicUI) -> void:
	print("this happens once we gain a new relic")
	
func activate_relic(owner: RelicUI) -> void:
	GC.lightning_tokens += 2
	GC.water_tokens += 2
	
func deactivate_relic(owner: RelicUI) -> void:
	print("this gets called when a RelicUI is exiting hte SceneTree")

func get_tooltip() -> String:
	return tooltip
