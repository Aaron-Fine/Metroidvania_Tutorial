extends CenterContainer

#TODO: Reduce duplication with StartMenu

onready var ClickSound:AudioStreamPlayer = $ClickSound
onready var HoverSound:AudioStreamPlayer = $HoverSound

func _on_QuitButton_pressed():
	ClickSound.play()
	yield(ClickSound, "finished")
	get_tree().quit()

func _on_LoadButton_pressed():
	ClickSound.play()
	Music.stop_music()
	SaverAndLoader.is_loading = true
	var err = get_tree().change_scene("res://World/World.tscn")
	assert(not err)
