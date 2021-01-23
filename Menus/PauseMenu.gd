extends ColorRect

var is_paused = false setget set_paused

func set_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused
	if is_paused:
		$PauseSound.play()
	else:
		$UnpauseSound.play()

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		set_paused(!is_paused)

func _on_ResumeButton_pressed():
	$ClickSound.play()
	set_paused(false)

func _on_QuitButton_pressed():
	$ClickSound.play()
	yield($ClickSound, "finished")
	get_tree().quit()

func _on_hover():
	$HoverSound.play()
