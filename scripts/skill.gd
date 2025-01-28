extends Resource
class_name Skill
@export var name: String
@export_category("Necessary")
@export var damage : int = 5
@export_enum("none", "water", "fire", "lightning", "earth", "grass") var element : String
@export var damaging = false
@export var healing = false
@export var shielding = false
@export_enum("single_enemy", "single_ally", "all_enemies", "all_allies", "all_units", "front_enemy", "front_ally", "back_enemy", "back_ally") var target_type : String

@export_category("Extras")
@export var friendly = false
@export var lifesteal = false
@export var lifesteal_rate : float = 1.0

@export_category("Cost")
@export var cost = 0
@export_enum("water", "fire", "lightning", "earth", "grass") var token_type : String
@export var cost2 = 0
@export_enum("water", "fire", "lightning", "earth", "grass") var token_type2 : String

@export var status_effects : Array = []


@export_category("Double Hit")
@export var double_hit = false
@export var damage2 : int = 0
@export_enum("none", "water", "fire", "lightning", "earth", "grass") var element2 : String

var final_damage : int

func _ready():
	final_damage = damage
func update():
	final_damage = damage
	#if unique == "Flameburst":
		#final_damage = ReactionManager.fire_count * damage
	
