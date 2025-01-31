class_name RelicUI
extends Control

@export var relic : Relic : set = set_relic

@onready var icon : TextureRect = $Icon
@onready var animation_player : AnimationPlayer = $AnimationPlayer
var shop = false


func _ready() -> void:

	flash()

func set_relic(new_relic: Relic) -> void:
	if not is_node_ready():
		await ready
	
	relic = new_relic
	icon.texture = relic.icon



	
func flash() -> void:
	animation_player.play("flash")
	

func _on_icon_mouse_entered() -> void:
	var combat = get_tree().get_first_node_in_group("combat")
	var shop = get_tree().get_first_node_in_group("shop")
	if combat:
		combat.relic_info.update_relic_info(relic)
		combat.toggle_relic_tooltip()
	elif shop:
		shop.relic_info.update_relic_info(relic)
		shop.toggle_relic_tooltip()


func _on_icon_mouse_exited() -> void:
	var shop = get_tree().get_first_node_in_group("shop")
	var combat = get_tree().get_first_node_in_group("combat")
	if combat:
		combat.relic_info.update_relic_info(relic)
		combat.toggle_relic_tooltip()
	elif shop:
		shop.relic_info.update_relic_info(relic)
		shop.toggle_relic_tooltip()
