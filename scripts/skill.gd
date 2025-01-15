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

@export var requirement = false
@export_enum("vaporize","detonate","shock") var reaction_requirement : String
@export var requirement_count = 0

@export var status_effects : Array = []
@export_enum("single_enemy", "single_ally", "all_enemies", "all_allies", "all_units") var target_type : String
@export_enum("Flameburst") var unique : String
var final_damage : int

func _ready():
	final_damage = damage
func update():
	if unique == "Flameburst":
		final_damage = ReactionManager.fire_count * damage
	
