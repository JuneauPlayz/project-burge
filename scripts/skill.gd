extends Resource
class_name Skill

@export var name: String
@export var damage : int = 5
@export var element : String = ""
@export var damaging = false
@export var healing = false
@export var shielding = false
@export var friendly = false
@export var requirement = false
@export_enum("vaporize","detonate","shock") var reaction_requirement : String
@export var requirement_count = 0

@export var status_effects : Array = []
@export_enum("single_enemy", "single_ally", "all_enemies", "all_allies", "all_units") var target_type : String
