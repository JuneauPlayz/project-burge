extends Node
@onready var firehit_noise: AudioStreamPlayer2D = $"firehit noise"



func _on_combat_manager_hit() -> void:
	firehit_noise.play()
	
