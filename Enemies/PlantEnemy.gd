extends "res://Enemies/Enemy.gd"

const EnemyBullet = preload("res://Enemies/EnemyBullet.tscn")

export var BULLET_SPEED:float = 30
export var SPREAD_DEGREES:float = 30

onready var fireDirection := $FireDirection as Position2D
onready var bulletSpawnPoint := $BulletSpawnPoint as Position2D

func fire_bullet():
	var bullet := Utils.instance_scene_on_main(
		EnemyBullet, 
		bulletSpawnPoint.global_position) as Projectile
	if not bullet:
		return
	var bullet_velocity := (fireDirection.global_position - 
							bulletSpawnPoint.global_position
							).normalized() * BULLET_SPEED
	bullet_velocity = bullet_velocity.rotated(
		deg2rad(rand_range(-SPREAD_DEGREES/2.0, SPREAD_DEGREES/2.0))
		)
	bullet.velocity = bullet_velocity
