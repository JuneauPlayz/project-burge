extends State
class_name SpellSelect
@onready var combat_manager: Node = %CombatManager

func _ready():
	pass
	
func Enter():
	pass
	


func _on_combat_manager_new_spell_selected() -> void:
	Transitioned.emit(self, "Targeting")
	
