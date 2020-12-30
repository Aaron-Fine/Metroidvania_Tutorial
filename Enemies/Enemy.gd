extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var MAX_SPEED := 15
export var ACCELERATION := 50

signal died

onready var stats := $EnemyStats as EnemyStats
onready var sprite := $Sprite as Sprite

var motion := Vector2.ZERO

func _on_Hurtbox_hit(damageDone:int):
	stats.health -= damageDone

func _on_EnemyStats_enemy_died():
# warning-ignore:return_value_discarded
	Utils.instance_scene_on_main(EnemyDeathEffect, global_position)
	queue_free()
	emit_signal("died")

func move(direction:Vector2, delta:float):
	motion += direction * ACCELERATION * delta
	motion = motion.clamped(MAX_SPEED)
	motion = move_and_slide(motion)
	
func chase_player(player:Player, delta:float):
	var direction_to_player := player.global_position - global_position
	direction_to_player = direction_to_player.normalized()
	
	# Move towards the player
	move(direction_to_player, delta)
	
	# Always face the player
	sprite.flip_h = global_position < player.global_position

