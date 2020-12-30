extends Control

func _ready():
	VisualServer.set_default_clear_color(Color.black)

func _on_StartButton_pressed():
	var err = get_tree().change_scene("res://World/World.tscn")
	if err:
		print(err)

func _on_LoadButton_pressed():
	SaverAndLoader.is_loading = true
	var err = get_tree().change_scene("res://World/World.tscn")
	if err:
		print(err)

func _on_QuitButton_pressed():
	get_tree().quit()
