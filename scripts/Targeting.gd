extends State
class_name Targeting

@onready var combat_manager: Node = %CombatManager

func Enter():
	pass
	


func _on_combat_manager_target_selected() -> void:
	Transitioned.emit(self, "SpellSelect")
