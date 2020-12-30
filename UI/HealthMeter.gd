extends Control

var PlayerStats = ResourceLoader.PlayerStats

onready var full = $Full
onready var empty = $Empty

const ONE_HEALTH_BAR_WIDTH = 5

func _ready():
	PlayerStats.connect("player_health_changed", self, "on_player_health_changed")
	PlayerStats.connect("max_health_changed", self, "on_max_health_changed")
	on_max_health_changed(PlayerStats.max_health)
	on_player_health_changed(PlayerStats.health)

func on_player_health_changed(value):
	full.rect_size.x = value * ONE_HEALTH_BAR_WIDTH + 1

func on_max_health_changed(value):
	empty.rect_size.x = value * ONE_HEALTH_BAR_WIDTH + 1
