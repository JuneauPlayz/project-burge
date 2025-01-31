class_name Relic
extends Resource

enum Type {START_OF_TURN, START_OF_COMBAT, END_OF_TURN, END_OF_COMBAT, EVENT_BASED}

@export var relic_name : String
@export_enum("1","2","3") var tier : String = "1"
@export var id : String
@export var type : Type
@export var icon : Texture
@export_multiline var tooltip : String

func initialize_relic(_owner : RelicUI) -> void:
	pass
	
# Should be implemented by event-based rleics which connect to the EventBus to make sure that they are disconnected when a relic gets removed
func deactivate_relic(_owner : RelicUI) -> void:
	pass
	
func get_tooltip() -> String:
	return tooltip
