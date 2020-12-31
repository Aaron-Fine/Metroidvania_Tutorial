extends HBoxContainer

var Stats := CommonResources.PlayerStats as PlayerStats

onready var label = $Label

func _ready():
	var err := Stats.connect(
		"player_missiles_changed", 
		self,
		"_on_player_missiles_changed")
	_on_player_missiles_changed(Stats.num_missiles)
	assert(not err)
	
	err = Stats.connect(
		"player_missiles_unlocked", 
		self, 
		"_on_player_missiles_unlocked")
	assert(not err)
	
	_on_player_missiles_unlocked(Stats.are_missiles_unlocked)

func _on_player_missiles_changed(amount:int):
	label.text = str(amount)

func _on_player_missiles_unlocked(value:bool):
	visible = value
