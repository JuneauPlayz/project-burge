extends Relic

var member_var = 0
@export var fire_damage_bonus : int
@export var fire_damage_mult : float
@export var water_damage_bonus : int
@export var water_damage_mult : float
@export var lightning_damage_bonus : int
@export var lightning_damage_mult : float
@export var earth_damage_bonus : int
@export var earth_damage_mult : float
@export var grass_damage_bonus : int
@export var grass_damage_mult : float
@export var healing_bonus : int
@export var healing_mult : float
@export var shielding_bonus : int
@export var shielding_mult : float


func initialize_relic(owner : RelicUI) -> void:
	# Elemental Damage Bonuses and Multipliers
	GC.fire_damage_bonus += self.fire_damage_bonus
	GC.fire_damage_mult += self.fire_damage_mult
	GC.water_damage_bonus += self.water_damage_bonus
	GC.water_damage_mult += self.water_damage_mult
	GC.lightning_damage_bonus += self.lightning_damage_bonus
	GC.lightning_damage_mult += self.lightning_damage_mult
	GC.earth_damage_bonus += self.earth_damage_bonus
	GC.earth_damage_mult += self.earth_damage_mult
	GC.grass_damage_bonus += self.grass_damage_bonus
	GC.grass_damage_mult += self.grass_damage_mult

	# Healing and Shielding Bonuses and Multipliers
	GC.healing_bonus += self.healing_bonus
	GC.healing_mult += self.healing_mult
	GC.shielding_bonus += self.shielding_bonus
	GC.shielding_mult += self.shielding_mult
	
func activate_relic(owner: RelicUI) -> void:
	print("this happens at specific times based on the Relic.Type property")
	
func deactivate_relic(owner: RelicUI) -> void:
	print("this gets called when a RelicUI is exiting hte SceneTree")

func get_tooltip() -> String:
	return tooltip
