extends Control

var Stats := CommonResources.PlayerStats as PlayerStats

onready var full = $Full
onready var empty = $Empty

const ONE_HEALTH_BAR_WIDTH = 5

func _ready():
	var err := Stats.connect("player_health_changed", self, "on_player_health_changed")
	assert(not err)
	err = Stats.connect("max_health_changed", self, "on_max_health_changed")
	assert(not err)
	on_max_health_changed(Stats.max_health)
	on_player_health_changed(Stats.health)

func on_player_health_changed(value:float):
	full.rect_size.x = value * ONE_HEALTH_BAR_WIDTH + 1

func on_max_health_changed(value:int):
	empty.rect_size.x = value * ONE_HEALTH_BAR_WIDTH + 1
