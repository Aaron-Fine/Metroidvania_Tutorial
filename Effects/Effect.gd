extends Node2D

export(float) var MIN_PITCH = 0.8
export(float) var MAX_PITCH = 1.4

onready var Sound:AudioStreamPlayer2D = $EffectSound

func _ready():
	Sound.pitch_scale = rand_range(MIN_PITCH, MAX_PITCH)
