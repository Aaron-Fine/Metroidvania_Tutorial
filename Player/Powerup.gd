extends Area2D
class_name Powerup

var PlayerStats := CommonResources.PlayerStats as PlayerStats

func _pickup():
	# Virtual function. Override this in derived script to implement powerup
	pass
