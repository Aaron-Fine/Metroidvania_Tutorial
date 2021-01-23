extends Control

onready var HoverSound = $HoverSound
onready var ClickSound = $ClickSound

func _ready():
	VisualServer.set_default_clear_color(Color.black)

func _on_StartButton_pressed():
	ClickSound.play()
	var err = get_tree().change_scene("res://World/World.tscn")
	assert(not err)

func _on_LoadButton_pressed():
	ClickSound.play()
	SaverAndLoader.is_loading = true
	var err = get_tree().change_scene("res://World/World.tscn")
	assert(not err)

func _on_QuitButton_pressed():
	ClickSound.play()
	yield(ClickSound, "finished")
	get_tree().quit()


func _on_hover():
	HoverSound.play()
