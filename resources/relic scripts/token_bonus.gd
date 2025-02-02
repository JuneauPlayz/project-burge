extends Relic

var member_var = 0
@export var fire_token_count : int
@export var water_token_count : int
@export var lightning_token_count : int
@export var earth_token_count : int
@export var grass_token_count : int

func initialize_relic(owner : RelicUI) -> void:
	print("this happens once we gain a new relic")
	
func activate_relic(owner: RelicUI) -> void:
	GC.fire_tokens += fire_token_count
	GC.water_tokens += water_token_count
	GC.lightning_tokens += lightning_token_count
	GC.earth_tokens += earth_token_count
	GC.grass_tokens += grass_token_count
	
func deactivate_relic(owner: RelicUI) -> void:
	print("this gets called when a RelicUI is exiting hte SceneTree")

func get_tooltip() -> String:
	return tooltip
