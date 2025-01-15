extends Node2D

func _on_exit_game_pressed() -> void:
	get_tree().quit()
	print("weeeee")


func _on_start_b_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main scenes/character_select.tscn")
