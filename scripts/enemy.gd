extends Unit
class_name Enemy

@export var skill : Skill
@export var current_element : String = "none"
@export var reaction_primed = 0
@onready var damage_number_origin: Node2D = $DamageNumberOrigin
@onready var current_element_text: Label = $CurrentElement
var hp_bar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#always make hp bar second child
	print(health)
	hp_bar = get_child(1)
	hp_bar.set_hp(health)
	hp_bar.set_maxhp(health)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func receive_skill(damage: float, element: String):
	var rounded : int
	var reaction = ""
	# no reaction
	if (!ReactionManager.reaction(current_element, element, self, damage)):
		self.take_damage(damage)
		DamageNumbers.display_number(damage, damage_number_origin.global_position, element, reaction)
		if (element != "none"):
			current_element = element
	current_element_text.text = "Current Element: " + current_element

func take_damage(damage : int):
	health -= damage
	hp_bar.set_hp(health)
	check_if_dead()

func check_if_dead():
	if health <= 0:
		die()

func die():
	print("ded")
