extends Control
@onready var vaporize_mult: Label = $PanelContainer/MarginContainer/Page1/Vaporize/VaporizeMult
@onready var vaporize_tokens: RichTextLabel = $PanelContainer/MarginContainer/Page1/VaporizeTokens
@onready var shock_mult: Label = $PanelContainer/MarginContainer/Page2/Shock/ShockMult
@onready var shock_tokens: RichTextLabel = $PanelContainer/MarginContainer/Page2/ShockTokens
@onready var detonate_mult: Label = $PanelContainer/MarginContainer/Page1/Detonate/DetonateMult
@onready var detonate_tokens: RichTextLabel = $PanelContainer/MarginContainer/Page1/DetonateTokens
@onready var erupt_mult: Label = $PanelContainer/MarginContainer/Page1/Erupt/EruptMult
@onready var erupt_tokens: RichTextLabel = $PanelContainer/MarginContainer/Page1/EruptTokens
@onready var bloom_healing: Label = $PanelContainer/MarginContainer/Page1/Bloom/BloomHealing
@onready var bloom_tokens: RichTextLabel = $PanelContainer/MarginContainer/Page1/BloomTokens
@onready var nitro_mult: Label = $PanelContainer/MarginContainer/Page2/Nitro/NitroMult
@onready var nitro_tokens: RichTextLabel = $PanelContainer/MarginContainer/Page2/NitroTokens
@onready var burn_damage: Label = $PanelContainer/MarginContainer/Page1/Burn/BurnDamage
@onready var burn_tokens: RichTextLabel = $PanelContainer/MarginContainer/Page1/BurnTokens
@onready var muck_mult: Label = $PanelContainer/MarginContainer/Page2/Muck/MuckMult
@onready var muck_tokens: RichTextLabel = $PanelContainer/MarginContainer/Page2/MuckTokens
@onready var discharge_mult: Label = $PanelContainer/MarginContainer/Page2/Discharge/DischargeMult
@onready var discharge_tokens: RichTextLabel = $PanelContainer/MarginContainer/Page2/DischargeTokens
@onready var sow_shielding: Label = $PanelContainer/MarginContainer/Page2/Sow/SowShielding
@onready var sow_tokens: RichTextLabel = $PanelContainer/MarginContainer/Page2/SowTokens



@onready var page_1: VBoxContainer = $PanelContainer/MarginContainer/Page1
@onready var page_2: VBoxContainer = $PanelContainer/MarginContainer/Page2
@onready var current_page_label: Label = $CurrentPage

var current_page = 1
var first_page = 1
var last_page = 2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	page_1.visible = true
	page_2.visible = false
	# loading time
	await get_tree().create_timer(0.6).timeout
	update_mult_labels()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_hide_pressed() -> void:
	get_parent().pressed.emit()


func _on_previous_page_pressed() -> void:
	if current_page != first_page:
		current_page -= 1
		change_page(current_page)


func _on_next_page_pressed() -> void:
	if current_page != last_page:
		current_page += 1
		change_page(current_page)

func change_page(page):
	current_page_label.text = "Page " + str(page)
	match page:
		1:
			page_1.visible = true
			page_2.visible = false
		2:
			page_1.visible = false
			page_2.visible = true

func update_mult_labels() -> void:
	# Update vaporize label
	vaporize_mult.text = "Vaporize Multiplier: " + str(GC.vaporize_mult) + "x"
	var fire_tokens = (GC.vaporize_fire_token_base + GC.vaporize_fire_token_bonus) * GC.vaporize_fire_token_mult
	var water_tokens = (GC.vaporize_water_token_base + GC.vaporize_water_token_bonus) * GC.vaporize_water_token_mult
	vaporize_tokens.text = "        +" + str(fire_tokens) + " [color=coral] Fire[/color]" + (" Tokens" if fire_tokens >= 2 else " Token") + "  +" + str(water_tokens) + " [color=darkcyan] Water[/color]" + (" Tokens" if water_tokens >= 2 else " Token")

	# Update shock label
	shock_mult.text = "Shock Multiplier: " + str(GC.shock_mult) + "x"
	var shock_water_tokens = (GC.shock_water_token_base + GC.shock_water_token_bonus) * GC.shock_water_token_mult
	var shock_lightning_tokens = (GC.shock_lightning_token_base + GC.shock_lightning_token_bonus) * GC.shock_lightning_token_mult
	shock_tokens.text = "        +" + str(shock_water_tokens) + " [color=darkcyan] Water[/color]" + (" Tokens" if shock_water_tokens >= 2 else " Token") + "  +" + str(shock_lightning_tokens) + " [color=purple] Lightning[/color]" + (" Tokens" if shock_lightning_tokens >= 2 else " Token")

	# Update detonate label
	detonate_mult.text = "Detonate Multiplier: " + str(GC.detonate_main_mult) + "x\nSide Multiplier: " + str(GC.detonate_side_mult) + "x"
	var detonate_fire_tokens = (GC.detonate_fire_token_base + GC.detonate_fire_token_bonus) * GC.detonate_fire_token_mult
	var detonate_lightning_tokens = (GC.detonate_lightning_token_base + GC.detonate_lightning_token_bonus) * GC.detonate_lightning_token_mult
	detonate_tokens.text = "        +" + str(detonate_fire_tokens) + " [color=coral] Fire[/color]" + (" Tokens" if detonate_fire_tokens >= 2 else " Token") + "  +" + str(detonate_lightning_tokens) + " [color=purple] Lightning[/color]" + (" Tokens" if detonate_lightning_tokens >= 2 else " Token")

	# Update erupt label
	erupt_mult.text = "Erupt Multiplier: " + str(GC.erupt_mult) + "x"
	var erupt_fire_tokens = (GC.erupt_fire_token_base + GC.erupt_fire_token_bonus) * GC.erupt_fire_token_mult
	var erupt_earth_tokens = (GC.erupt_earth_token_base + GC.erupt_earth_token_bonus) * GC.erupt_earth_token_mult
	erupt_tokens.text = "        +" + str(erupt_fire_tokens) + " [color=coral] Fire[/color]" + (" Tokens" if erupt_fire_tokens >= 2 else " Token") + "  +" + str(erupt_earth_tokens) + " [color=saddlebrown] Earth[/color]" + (" Tokens" if erupt_earth_tokens >= 2 else " Token")

	# Update bloom label
	bloom_healing.text = "Bloom Healing: " + str(GC.ally_bloom_healing)
	var bloom_water_tokens = (GC.bloom_water_token_base + GC.bloom_water_token_bonus) * GC.bloom_water_token_mult
	var bloom_grass_tokens = (GC.bloom_grass_token_base + GC.bloom_grass_token_bonus) * GC.bloom_grass_token_mult
	bloom_tokens.text = "        +" + str(bloom_water_tokens) + " [color=darkcyan] Water[/color]" + (" Tokens" if bloom_water_tokens >= 2 else " Token") + "  +" + str(bloom_grass_tokens) + " [color=webgreen] Grass[/color]" + (" Tokens" if bloom_grass_tokens >= 2 else " Token")

	# Update nitro label
	nitro_mult.text = "Nitro Multiplier: " + str(GC.nitro_mult) + "x"
	var nitro_lightning_tokens = (GC.nitro_lightning_token_base + GC.nitro_lightning_token_bonus) * GC.nitro_lightning_token_mult
	var nitro_grass_tokens = (GC.nitro_grass_token_base + GC.nitro_grass_token_bonus) * GC.nitro_grass_token_mult
	nitro_tokens.text = "        +" + str(nitro_lightning_tokens) + " [color=purple] Lightning[/color]" + (" Tokens" if nitro_lightning_tokens >= 2 else " Token") + "  +" + str(nitro_grass_tokens) + " [color=webgreen] Grass[/color]" + (" Tokens" if nitro_grass_tokens >= 2 else " Token")

	# Update burn label
	burn_damage.text = "Burn Damage: " + str(GC.burn_damage) + "\nBurn Length: " + str(GC.burn_length) + " turns"
	var burn_fire_tokens = (GC.burn_fire_token_base + GC.burn_fire_token_bonus) * GC.burn_fire_token_mult
	var burn_grass_tokens = (GC.burn_grass_token_base + GC.burn_grass_token_bonus) * GC.burn_grass_token_mult
	burn_tokens.text = "        +" + str(burn_fire_tokens) + " [color=coral] Fire[/color]" + (" Tokens" if burn_fire_tokens >= 2 else " Token") + "  +" + str(burn_grass_tokens) + " [color=webgreen] Grass[/color]" + (" Tokens" if burn_grass_tokens >= 2 else " Token")

	# Update muck label
	muck_mult.text = "Muck Multiplier: " + str(GC.muck_mult) + "x"
	var muck_water_tokens = (GC.muck_water_token_base + GC.muck_water_token_bonus) * GC.muck_water_token_mult
	var muck_earth_tokens = (GC.muck_earth_token_base + GC.muck_earth_token_bonus) * GC.muck_earth_token_mult
	muck_tokens.text = "        +" + str(muck_water_tokens) + " [color=darkcyan] Water[/color]" + (" Tokens" if muck_water_tokens >= 2 else " Token") + "  +" + str(muck_earth_tokens) + " [color=saddlebrown] Earth[/color]" + (" Tokens" if muck_earth_tokens >= 2 else " Token")

	# Update discharge label
	discharge_mult.text = "Discharge Multiplier: " + str(GC.discharge_mult) + "x"
	var discharge_earth_tokens = (GC.discharge_earth_token_base + GC.discharge_earth_token_bonus) * GC.discharge_earth_token_mult
	var discharge_lightning_tokens = (GC.discharge_lightning_token_base + GC.discharge_lightning_token_bonus) * GC.discharge_lightning_token_mult
	discharge_tokens.text = "        +" + str(discharge_earth_tokens) + " [color=saddlebrown] Earth[/color]" + (" Tokens" if discharge_earth_tokens >= 2 else " Token") + "  +" + str(discharge_lightning_tokens) + " [color=purple] Lightning[/color]" + (" Tokens" if discharge_lightning_tokens >= 2 else " Token")

	# Update sow label
	sow_shielding.text = "Sow Shielding: " + str(GC.sow_shielding) + "\nSow Healing: " + str(GC.sow_healing)
	var sow_earth_tokens = (GC.sow_earth_token_base + GC.sow_earth_token_bonus) * GC.sow_earth_token_mult
	var sow_grass_tokens = (GC.sow_grass_token_base + GC.sow_grass_token_bonus) * GC.sow_grass_token_mult
	sow_tokens.text = "        +" + str(sow_earth_tokens) + " [color=saddlebrown] Earth[/color]" + (" Tokens" if sow_earth_tokens >= 2 else " Token") + "  +" + str(sow_grass_tokens) + " [color=webgreen] Grass[/color]" + (" Tokens" if sow_grass_tokens >= 2 else " Token")
