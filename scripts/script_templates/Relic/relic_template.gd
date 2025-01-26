# meta-name Relic
# meta-description: Create a Relio which can be acquired by the player.

extends Relic

var member_var = 0

func initialize_relic(owner : RelicUI) -> void:
	print("this happens once we gain a new relic")
	
func activate_relic(owner: RelicUI) -> void:
	print("this happens at specific times based on the Relic.Type property")
	
func deactivate_relic(owner: RelicUI) -> void:
	print("this gets called when a RelicUI is exiting hte SceneTree")

func get_tooltip() -> String:
	return tooltip
