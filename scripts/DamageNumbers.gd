extends Node
var element_dict = {"none": Color.WHITE, "fire": Color.CORAL, "water": Color.AQUA, "lightning": Color.PURPLE, "earth": Color.SADDLE_BROWN}
func display_number(value: int, position: Vector2, element : String, reaction : String):
	var number = Label.new()
	value = -value
	number.global_position = position
	number.text = str(value) + reaction
	number.z_index = 5
	number.label_settings = LabelSettings.new()
	
	var color = element_dict.get(element)
	
	
	number.label_settings.font_color = color
	number.label_settings.font_size = 38
	number.label_settings.outline_color = "#000"
	number.label_settings.outline_size = 1
	
	call_deferred("add_child", number)
	await number.resized
	number.pivot_offset = Vector2(number.size / 2)
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		number, "position:y", number.position.y - 24, 0.15
	).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		number, "position:y", number.position.y+25, 0.25
	).set_ease(Tween.EASE_IN).set_delay(0.4)
	tween.tween_property(
		number, "scale", number.scale*0.5, 0.25
	).set_ease(Tween.EASE_IN).set_delay(0.5)
	
	await tween.finished
	number.queue_free()
