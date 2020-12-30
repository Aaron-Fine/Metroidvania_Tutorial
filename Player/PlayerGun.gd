extends Node2D
class_name PlayerGun

func _process(_delta):
	var player:Node = get_parent()
	if not player:
		return
	
	rotation = player.get_local_mouse_position().angle()
