extends Unit
class_name Ally

@export var basic_atk : Skill
@export var skill_1: Skill
@export var skill_2: Skill
@export var ult: Skill

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_child(0).skill1 = basic_atk
	get_child(0).skill2 = skill_1
	get_child(0).skill3 = skill_2
	get_child(0).skill4 = ult
	get_child(0).load_skills()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
