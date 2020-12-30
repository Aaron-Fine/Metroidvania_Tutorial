extends "res://Enemies/Enemy.gd"

var MainInstances = ResourceLoader.MainInstances

func _ready():
	# We don't want to chase the player unless we can see them, so start by
	# turning off the physics process and turning it on other ways
	set_physics_process(false)

func _physics_process(delta:float):
	var player := (MainInstances as MainInstances).Player as Player
	if player == null:
		return
	
	chase_player(player, delta)

func _on_VisibilityNotifier2D_screen_entered():
	set_physics_process(true)
