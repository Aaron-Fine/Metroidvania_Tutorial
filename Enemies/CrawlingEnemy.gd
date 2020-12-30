extends "res://Enemies/Enemy.gd"

enum DIRECTION {
	LEFT = -1
	RIGHT = 1
}

const SPEED_CORRECTION_FACTOR = 10

export(DIRECTION) var WALKING_DIRECTION = DIRECTION.RIGHT

onready var floorCast = $FloorRayCast
onready var wallCast = $WallRayCast

var SPEED = 0

func _ready():
	wallCast.cast_to.x *= WALKING_DIRECTION
	SPEED = MAX_SPEED * SPEED_CORRECTION_FACTOR

func _physics_process(delta):
	if wallCast.is_colliding():
		global_position = wallCast.get_collision_point()
		# Match wall angle
		rotate_to_normal(wallCast.get_collision_normal())
	else:
		floorCast.rotation_degrees = -SPEED * WALKING_DIRECTION * delta
		if floorCast.is_colliding():
			global_position = floorCast.get_collision_point()
			# Match floor angle
			rotate_to_normal(floorCast.get_collision_normal())
		else:
			# We are at a corner. Rotate around it.
			rotation_degrees += 20 * WALKING_DIRECTION
	
func rotate_to_normal(normal):
	rotation = normal.rotated(deg2rad(90)).angle()
