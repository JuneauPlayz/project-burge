extends Control
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var hptext: Label = $HP
var max_hp = 0
var hp = 0

func set_hp(newhp):
	hp = newhp
	progress_bar.value = hp
	update_text()

func set_maxhp(newhp):
	max_hp = newhp
	progress_bar.max_value = max_hp
	progress_bar.value = hp
	update_text()

func update_text():
	hptext.text = str(hp) + " / " + str(max_hp)
