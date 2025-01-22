extends Control


var selected = 0
signal new_select
@export var char : int

@onready var ba_1: Button = $PanelContainer/MarginContainer/VBoxContainer/BA1Panel/ba_1
@onready var s_1: Button = $PanelContainer/MarginContainer/VBoxContainer/SP1Panel/S1
@onready var s_2: Button = $PanelContainer/MarginContainer/VBoxContainer/SP2Panel/S2
@onready var ult: Button = $PanelContainer/MarginContainer/VBoxContainer/ULTPanel/ULT
@onready var positionL : Label = $Position

var element_dict = {"none": Color.WHITE, "fire": Color.CORAL, "water": Color.DARK_CYAN, "lightning": Color.PURPLE, "earth": Color.SADDLE_BROWN, "grass": Color.WEB_GREEN}

var skill1 : Skill
var skill2 : Skill
var skill3 : Skill
var skill4 : Skill

@onready var skill_info_1: Control = $SkillInfo
@onready var skill_info_2: Control = $SkillInfo2
@onready var skill_info_3: Control = $SkillInfo3
@onready var skill_info_4: Control = $SkillInfo4

var initial_load = false

var blue = Color("3f61a1")
var gray = Color("2e2e2e78")

func load_skills():
	skill1.update()
	update_font_color(ba_1,element_dict.get(skill1.element))
	skill2.update()
	update_font_color(s_1,element_dict.get(skill2.element))
	skill3.update()
	update_font_color(s_2,element_dict.get(skill3.element))
	skill4.update()
	update_font_color(ult,element_dict.get(skill4.element))
	skill_info_1.skill = skill1
	skill_info_1.update_skill_info()
	skill_info_2.skill = skill2
	skill_info_2.update_skill_info()
	skill_info_3.skill = skill3
	skill_info_3.update_skill_info()
	skill_info_4.skill = skill4
	skill_info_4.update_skill_info()
	ba_1.text = skill1.name
	s_1.text = skill2.name
	s_2.text = skill3.name
	ult.text = skill4.name
	if not initial_load:
		if skill1.cost > 0:
			ba_1.disabled = true
		if skill2.cost > 0:
			s_1.disabled = true
		if skill3.cost > 0:
			s_2.disabled = true
		if skill4.cost > 0:
			ult.disabled = true
		initial_load = true

func _on_button_pressed() -> void:
	if selected != 1:
		selected = 1
	else:
		selected = 0
	update()

func _on_s_1_pressed() -> void:
	if selected != 2:
		selected = 2
	else:
		selected = 0
	update()

func _on_s_2_pressed() -> void:
	if selected != 3:
		selected = 3
	else:
		selected = 0
	update()
	
func _on_ult_pressed() -> void:
	if selected != 4:
		selected = 4
	else:
		selected = 0
	update()
	
func update():
	new_select.emit(get_parent())
	match selected:
		0:
			update_color(ba_1, gray)
			update_color(s_1, gray)
			update_color(s_2, gray)
			update_color(ult, gray)
		1:
			update_color(ba_1, blue)
			update_color(s_1, gray)
			update_color(s_2, gray)
			update_color(ult, gray)
		2:
			update_color(ba_1, gray)
			update_color(s_1, blue)
			update_color(s_2, gray)
			update_color(ult, gray)
		3:
			update_color(ba_1, gray)
			update_color(s_1, gray)
			update_color(s_2, blue)
			update_color(ult, gray)
		4:
			update_color(ba_1, gray)
			update_color(s_1, gray)
			update_color(s_2, gray)
			update_color(ult, blue)
	
func update_color(button, color):
	var new_stylebox_normal = button.get_theme_stylebox("normal").duplicate()
	new_stylebox_normal.bg_color = color
	button.add_theme_stylebox_override("normal", new_stylebox_normal)
	
	
func update_font_color(button, color):
	button.add_theme_color_override("font_color", color)

	
func update_pos(pos):
	if pos > 0:
		positionL.text = "Position: " + str(pos)
	else:
		positionL.text = "Position: "
	
func reset():
	update_color(ba_1, gray)
	update_color(s_1, gray)
	update_color(s_2, gray)
	update_color(ult, gray)
	selected = 0
	
func enable(num):
	match num:
		1:
			ba_1.disabled = false
		2:
			s_1.disabled = false
		3:
			s_2.disabled = false
		4:
			ult.disabled = false
			print("enabling ult")
			update_font_color(ult, Color.INDIAN_RED)
			
func disable(num):
	match num:
		1:
			ba_1.disabled = true
		2:
			s_1.disabled = true
		3:
			s_2.disabled = true
		4:
			ult.disabled = true

func _on_ba_1_mouse_entered() -> void:
	skill_info_1.visible = true


func _on_s_1_mouse_entered() -> void:
	skill_info_2.visible = true


func _on_s_2_mouse_entered() -> void:
	skill_info_3.visible = true


func _on_ult_mouse_entered() -> void:
	skill_info_4.visible = true


func _on_ba_1_mouse_exited() -> void:
	skill_info_1.visible = false


func _on_s_1_mouse_exited() -> void:
	skill_info_2.visible = false


func _on_s_2_mouse_exited() -> void:
	skill_info_3.visible = false


func _on_ult_mouse_exited() -> void:
	skill_info_4.visible = false
