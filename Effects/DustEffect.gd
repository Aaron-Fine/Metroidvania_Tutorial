extends "res://Effects/Effect.gd"

var motion = Vector2(rand_range(-20, 20), rand_range(-10, -40))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += motion * delta
