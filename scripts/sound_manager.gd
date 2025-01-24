extends Node
@onready var firehit_noise: AudioStreamPlayer2D = $"firehit noise"
@onready var click_noise: AudioStreamPlayer2D = $"click noise"
@onready var og_music: AudioStreamPlayer2D = $"og music"
@onready var zinnia_theme: AudioStreamPlayer2D = $"zinnia theme"
@onready var crimson_highlands: AudioStreamPlayer2D = $"crimson highlands"



func _on_combat_manager_hit() -> void:
	firehit_noise.play()
	


func _on_combat_manager_click() -> void:
	click_noise.play()

func play_song(song):
	match song:
		"og":
			og_music.play()
		"zinnia":
			zinnia_theme.play()
		"crimson":
			crimson_highlands.play()
