extends Area2D
class_name Powerup

var PlayerStats := CommonResources.PlayerStats as PlayerStats

onready var Envionrmental:AudioStreamPlayer2D = $EnvionrmentalAudio
onready var PickupSound:AudioStreamPlayer2D = $PickupSound

func _pickup():
	PickupSound.play()

func _process(_delta:float):
	if !Envionrmental.playing:
		Envionrmental.play()
