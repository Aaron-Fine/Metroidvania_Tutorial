extends "res://Enemies/Enemy.gd"

var MainInstance := ResourceLoader.MainInstances as MainInstances

const Bullet := preload("res://Enemies/EnemyBullet.tscn")

export var LEAN_STRENGTH = 10
export var BULLET_VELOCITY = 50
export var SPREAD_DEGREES:float = 30

onready var rightWallCheck := $RightWallCheck as RayCast2D
onready var leftWallCheck := $LeftWallCheck as RayCast2D

func _physics_process(delta:float):
	var player:Player = MainInstance.Player
	if player == null:
		return
	var direction_to_move := sign(player.global_position.x - global_position.x)
	move(Vector2(direction_to_move, 0), delta)
	
	# Lean towards the player
	rotation_degrees = lerp(rotation_degrees, 
							(motion.x / MAX_SPEED) * LEAN_STRENGTH, 
							0.3)
	
	if (rightWallCheck.is_colliding() and motion.x > 0) or (leftWallCheck.is_colliding() and motion.x < 0) :
		motion.x *= -0.5

func fire_bullet():
	# TODO: Refactor this and Plant Enemy
	var bullet = Utils.instance_scene_on_main(Bullet, global_position) as Projectile
	if not bullet:
		return
	var bullet_velocity = Vector2.DOWN * BULLET_VELOCITY
	bullet_velocity = bullet_velocity.rotated(
		deg2rad(rand_range(-SPREAD_DEGREES/2.0, SPREAD_DEGREES/2.0))
		)
	bullet.velocity = bullet_velocity

func _on_FireTimer_timeout():
	fire_bullet()
