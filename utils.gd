extends Node

func instance_scene_on_main(scene:PackedScene, position:Vector2) -> Node2D:
	var instance := scene.instance() as Node2D
	if not instance:
		print("Could not instance scene on main! Returning an empty Node2D")
		return Node2D.instance()
	instance.global_position = position
	get_tree().current_scene.add_child(instance)
	return instance
