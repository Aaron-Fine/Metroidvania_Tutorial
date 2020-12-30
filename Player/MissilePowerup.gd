extends Powerup

func _pickup():
	PlayerStats.are_missiles_unlocked = true
	queue_free()
