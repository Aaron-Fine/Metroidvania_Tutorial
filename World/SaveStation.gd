extends StaticBody2D

onready var animPlayer := $AnimationPlayer as AnimationPlayer
onready var saveTimer := $Timer as Timer

func _on_SaveArea_body_entered(_body):
	if saveTimer.time_left == 0:
		animPlayer.play("Save")
		SaverAndLoader.save_game()
		saveTimer.start()
