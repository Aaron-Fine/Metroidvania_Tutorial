extends Area2D
class_name Hurtbox
"""
Hurtbox gets damaged by a Hitbox
"""

signal hit(damage)

onready var HurtSound:AudioStreamPlayer2D = $AudioStreamPlayer2D 

func _on_Hurtbox_hit(damage):
	HurtSound.play()
