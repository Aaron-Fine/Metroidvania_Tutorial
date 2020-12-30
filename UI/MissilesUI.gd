extends HBoxContainer

var PlayerStats = ResourceLoader.PlayerStats

onready var label = $Label

func _ready():
	PlayerStats.connect(
		"player_missiles_changed", 
		self,
		"_on_player_missiles_changed")
	_on_player_missiles_changed(PlayerStats.num_missiles)
	
	PlayerStats.connect(
		"player_missiles_unlocked", 
		self, 
		"_on_player_missiles_unlocked")
	_on_player_missiles_unlocked(PlayerStats.are_missiles_unlocked)

func _on_player_missiles_changed(amount:int):
	label.text = str(amount)

func _on_player_missiles_unlocked(value:bool):
	visible = value
