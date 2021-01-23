extends Node2D
class_name Projectile

const ExplosionEffect = preload("res://Effects/ExplosionEffect.tscn")

export(float) var MIN_PITCH = 0.8
export(float) var MAX_PITCH = 1.4

onready var Audio:AudioStreamPlayer2D = $AudioStreamPlayer2D

var velocity := Vector2.ZERO

func _ready():
	Audio.pitch_scale = rand_range(MIN_PITCH, MAX_PITCH)

func _process(delta:float):
	position += velocity * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Hitbox_body_entered(_body):
# warning-ignore:return_value_discarded
	Utils.instance_scene_on_main(ExplosionEffect, global_position)
	queue_free()

func _on_Hitbox_area_entered(_area):
# warning-ignore:return_value_discarded
	Utils.instance_scene_on_main(ExplosionEffect, global_position)
	queue_free()
