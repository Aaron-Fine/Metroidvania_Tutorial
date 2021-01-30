extends Node

export (Array, AudioStream) var music_list = []

var music_list_index := 0

onready var musicPlayer:AudioStreamPlayer = $AudioStreamPlayer

func _ready():
	music_list.shuffle()

func play_music():
	assert(music_list.size() > 0)
	musicPlayer.stream = music_list[music_list_index]
	musicPlayer.play()
	
	# increment index with looping
	music_list_index += 1
	if music_list_index >= music_list.size():
		music_list_index = 0

func stop_music():
	musicPlayer.stop()

func _on_AudioStreamPlayer_finished():
	play_music()
