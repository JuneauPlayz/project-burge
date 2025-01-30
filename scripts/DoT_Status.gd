extends Resource
class_name Dot_Status

@export var name : String
@export var pre_turn : bool
@export var damage : int
@export_enum("none", "water", "fire", "lightning", "earth", "grass") var element : String
@export var turns_remaining : int
@export_enum("bubble") var unique_type : String
