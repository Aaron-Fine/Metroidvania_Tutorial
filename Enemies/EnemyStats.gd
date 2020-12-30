extends Node
class_name EnemyStats

signal enemy_died
signal overkilled

export var max_health:int = 1

onready var health:float = max_health setget set_health

func set_health(val:float):
	health = val
	if health <= 0:
		emit_signal("enemy_died")
	
	if health <= -max_health:
		emit_signal("overkilled")
