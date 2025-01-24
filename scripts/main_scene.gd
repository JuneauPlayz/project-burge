extends Node2D
@onready var click: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _on_exit_game_pressed() -> void:
	get_tree().quit()


func _on_start_b_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main scenes/character_select.tscn")
