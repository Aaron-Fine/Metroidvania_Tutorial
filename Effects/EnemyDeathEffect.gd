extends Node2D

func _process(_delta):
	if self.get_children().empty():
		queue_free()
