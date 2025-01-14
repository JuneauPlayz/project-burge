extends Node
@onready var firehit_noise: AudioStreamPlayer2D = $"firehit noise"
@onready var click_noise: AudioStreamPlayer2D = $"click noise"



func _on_combat_manager_hit() -> void:
	firehit_noise.play()
	


func _on_combat_manager_click() -> void:
	click_noise.play()
