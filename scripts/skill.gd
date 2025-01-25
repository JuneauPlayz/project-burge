extends Resource
class_name Skill

@export var name: String
@export var damage : int = 5
@export_enum("none", "water", "fire", "lightning", "earth", "grass") var element : String
@export var damaging = false
@export var healing = false
@export var shielding = false
@export var friendly = false

@export var double_hit = false
@export var damage2 : int = 0
@export_enum("none", "water", "fire", "lightning", "earth", "grass") var element2 : String



@export var cost = 0
@export_enum("water", "fire", "lightning", "earth", "grass") var token_type : String
@export var cost2 = 0
@export_enum("water", "fire", "lightning", "earth", "grass") var token_type2 : String

@export var status_effects : Array = []
@export_enum("single_enemy", "single_ally", "all_enemies", "all_allies", "all_units", "front_enemy", "front_ally") var target_type : String
@export_enum("Flameburst") var unique : String
var final_damage : int

func _ready():
	final_damage = damage
func update():
	final_damage = damage
	#if unique == "Flameburst":
		#final_damage = ReactionManager.fire_count * damage
	
