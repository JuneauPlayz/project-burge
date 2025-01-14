extends Node2D

@onready var combat_manager: Node = %CombatManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	combat_manager = get_child(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_combat_manager():
	return combat_manager
