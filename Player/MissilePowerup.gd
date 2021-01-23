extends Powerup

func _pickup():
	PlayerStats.are_missiles_unlocked = true
	PlayerStats.num_missiles += 3
	PickupSound.play()
	yield(PickupSound, "finished")
	queue_free()
