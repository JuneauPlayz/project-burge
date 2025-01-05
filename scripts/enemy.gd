extends Unit
class_name Enemy

@export var skill1 : Skill
@export var skill2 : Skill
var current_skill : Skill
@export var current_element : String = "none"
@export var reaction_primed = 0
@onready var damage_number_origin: Node2D = $DamageNumberOrigin
var hp_bar
@onready var skill_info: Control = $ShowNextSkill/SkillInfo

signal skill_end
signal reaction_ended

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#always mak	e hp bar second child
	current_skill = skill1
	skill_info.skill = current_skill
	skill_info.update_skill_info()
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
	ReactionManager.reaction_finished.connect(self.reaction_signal)
	var r = await ReactionManager.reaction(current_element, element, self, damage, 1)
	if (r):
		print("waiting")
		await reaction_ended 
		print("waiting finished")
	# no reaction
	if (!r):
		self.take_damage(damage)
		DamageNumbers.display_number(damage, damage_number_origin.global_position, element, reaction)
		check_if_dead()
		# don't change current element if skill has no element
		if (element != "none"):
			current_element = element
	hp_bar.update_element(current_element)


func reaction_signal():
	print("reaction signal received")
	reaction_ended.emit()
	
	

func take_damage(damage : int):
	health -= damage
	hp_bar.set_hp(health)

func check_if_dead():
	if health <= 0:
		die()

func die():
	print("ded")
	
func change_skills():
	if current_skill == skill1:
		current_skill = skill2
	elif current_skill == skill2:
		current_skill = skill1
	skill_info.skill = current_skill
	skill_info.update_skill_info()
	
