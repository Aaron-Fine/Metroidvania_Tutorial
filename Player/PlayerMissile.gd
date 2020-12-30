extends "res://Player/Projectile.gd"
class_name PlayerMissile

const DESTRUCTION_EFFECT = preload("res://Effects/EnemyDeathEffect.tscn")

const BRICK_LAYER_BIT = 4
const BRIC_CENTER_OFFSET = Vector2(8, 8)

func _on_Hitbox_body_entered(body):
	._on_Hitbox_body_entered(body)
	if body.get_collision_layer_bit(BRICK_LAYER_BIT):
# warning-ignore:return_value_discarded
		Utils.instance_scene_on_main(
			DESTRUCTION_EFFECT, 
			body.global_position + BRIC_CENTER_OFFSET)
		body.queue_free()
