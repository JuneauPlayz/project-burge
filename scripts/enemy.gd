extends Unit
class_name Enemy

@export var skill : Skill
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func take_damage(damage: float):
	var rounded: int
	rounded = roundi(damage)
	health -= rounded
	check_if_dead()
	

func check_if_dead():
	if health <= 0:
		die()

func die():
	print("ded")
