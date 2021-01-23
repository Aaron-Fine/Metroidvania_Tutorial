extends StaticBody2D

var Stats := CommonResources.PlayerStats as PlayerStats

onready var animPlayer := $AnimationPlayer as AnimationPlayer
onready var saveTimer := $Timer as Timer
onready var saveSound := $SaveSound as AudioStreamPlayer2D

func _on_SaveArea_body_entered(_body):
	if saveTimer.time_left == 0:
		animPlayer.play("Save")
		SaverAndLoader.save_game()
		saveTimer.start()
		Stats.refil_stats()
		saveSound.play()
