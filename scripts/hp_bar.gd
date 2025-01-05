extends Control
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var hptext: Label = $HP
var max_hp = 0
var hp = 0
var shield = 0
@onready var current_element: Label = $CurrentElement
@onready var shield_bar: ProgressBar = $ShieldBar
@onready var shield_spr: Sprite2D = $Shield
@onready var shield_label: Label = $ShieldLabel

func set_hp(newhp):
	hp = newhp
	progress_bar.value = hp
	update_text()

func set_maxhp(newhp):
	max_hp = newhp
	progress_bar.max_value = max_hp
	progress_bar.value = hp
	shield_bar.max_value = max_hp
	update_text()

func set_shield(newshield):
	shield = newshield
	shield_bar.value = shield
	update_text()
	
func update_text():
	hptext.text = str(hp) + " / " + str(max_hp)
	if (shield > 0):
		shield_bar.visible = true
		shield_spr.visible = true
		shield_label.visible = true
		shield_label.text = str(shield)
	else:
		shield_label.visible = false
		shield_bar.visible = false
		shield_spr.visible = false
		
		

func update_element(element):
	current_element.text = "Element: " + element
