extends ColorRect

var is_paused = false setget set_paused

func set_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		set_paused(!is_paused)

func _on_ResumeButton_pressed():
	set_paused(false)


func _on_QuitButton_pressed():
	get_tree().quit()
