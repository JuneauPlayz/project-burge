extends Control

@onready var fire_count: Label = $PanelContainer/MarginContainer/VBoxContainer/Control/FireCount
@onready var water_count: Label = $PanelContainer/MarginContainer/VBoxContainer/Control2/WaterCount
@onready var lightning_count: Label = $PanelContainer/MarginContainer/VBoxContainer/Control3/LightningCount
@onready var grass_count: Label = $PanelContainer/MarginContainer/VBoxContainer/Control4/GrassCount
@onready var earth_count: Label = $PanelContainer/MarginContainer/VBoxContainer/Control5/EarthCount


func update():
	fire_count.text = str(GC.fire_tokens)
	water_count.text = str(GC.water_tokens)
	lightning_count.text = str(GC.lightning_tokens)
	grass_count.text = str(GC.grass_tokens)
	earth_count.text = str(GC.earth_tokens)
