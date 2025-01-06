extends Unit
class_name Enemy_COPY

@export var skill1 : Skill
@export var skill2 : Skill
var current_skill : Skill
@export var current_element : String = "none"
@export var reaction_primed = 0
@export var status : Array = []
@onready var damage_number_origin: Node2D = $DamageNumberOrigin
var hp_bar
@onready var skill_info: Control = $ShowNextSkill/SkillInfo
var connected = false

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
	

func receive_skill(skill):
	var rounded : int
	var reaction = ""
	if (!connected):
		ReactionManager.reaction_finished.connect(self.reaction_signal)
		connected = true
	var r = await ReactionManager.reaction(current_element, skill.element, self, skill.damage, 1)
	if (r):
		print("waiting")
		await reaction_ended 
		print("waiting finished")
	# no reaction
	if (!r):
		self.take_damage(skill.damage)
		DamageNumbers.display_number(skill.damage, damage_number_origin.global_position, skill.element, reaction)
		check_if_dead()
		# don't change current element if skill has no element
		if (skill.element != "none"):
			current_element = skill.element
	#handle status effects
	if skill.status_effects != []:
		for x in skill.status_effects:
			status.append(x)
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
	
func execute_status(status_effect):
	take_damage(status_effect.damage)
	DamageNumbers.display_number(status_effect.damage, damage_number_origin.global_position, status_effect.element, "")
	status_effect.turns_remaining -= 1
	if status_effect.turns_remaining == 0:
		status.erase(status_effect)
