extends Relic

var member_var = 0
@export var vaporize_mult : float
@export var shock_mult : float
@export var erupt_mult : float
@export var detonate_main_mult : float
@export var detonate_side_mult : float
@export var nitro_mult : float
@export var burn_damage : float
@export var burn_length : float
@export var muck_mult : float
@export var discharge_mult : float
@export var sow_shielding : float
@export var sow_healing : float
@export var sow_healing_mult : float
@export var sow_shielding_mult : float
@export var bloom_mult : float
@export var bubble_mult : float
@export var ally_bloom_healing : float
@export var enemy_bloom_healing : float

func initialize_relic(owner : RelicUI) -> void:
	GC.vaporize_mult += self.vaporize_mult
	GC.shock_mult += self.shock_mult
	GC.erupt_mult += self.erupt_mult
	GC.detonate_main_mult += self.detonate_main_mult
	GC.detonate_side_mult += self.detonate_side_mult
	GC.nitro_mult += self.nitro_mult
	GC.burn_damage += self.burn_damage
	GC.burn_length += self.burn_length
	GC.muck_mult += self.muck_mult
	GC.discharge_mult += self.discharge_mult
	GC.sow_shielding += self.sow_shielding
	GC.sow_healing += self.sow_healing
	GC.sow_healing_mult += self.sow_healing_mult
	GC.sow_shielding_mult += self.sow_shielding_mult
	GC.bloom_mult += self.bloom_mult
	GC.bubble_mult += self.bubble_mult
	GC.ally_bloom_healing += self.ally_bloom_healing
	
func activate_relic(owner: RelicUI) -> void:
	print("this happens at specific times based on the Relic.Type property")
	
func deactivate_relic(owner: RelicUI) -> void:
	print("this gets called when a RelicUI is exiting hte SceneTree")

func get_tooltip() -> String:
	return tooltip
