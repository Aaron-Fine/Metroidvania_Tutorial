extends "res://Enemies/Enemy.gd"

enum DIRECTION {
	LEFT = -1,
	RIGHT = 1,
}

export(DIRECTION) var WALKING_DIRECTION = DIRECTION.RIGHT

var state

onready var floorLeft = $FloorLeft
onready var floorRight = $FloorRight
onready var wallLeft = $WallLeft
onready var wallRight = $WallRight

func _ready():
	motion.y = 8
	state = WALKING_DIRECTION

func _physics_process(_delta:float):
	match state:
		DIRECTION.RIGHT:
			motion.x = MAX_SPEED
			if not floorRight.is_colliding() or wallRight.is_colliding():
				state = DIRECTION.LEFT
		DIRECTION.LEFT:
			motion.x = -MAX_SPEED
			if not floorLeft.is_colliding() or wallLeft.is_colliding():
				state = DIRECTION.RIGHT
	sprite.scale.x = sign(motion.x)
	motion = move_and_slide_with_snap(
									motion, 
									Vector2.DOWN * 4, 
									Vector2.UP, 
									true,
									4,
									deg2rad(46))




