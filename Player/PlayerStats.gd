extends Resource
class_name PlayerStats

# Note adding custom types here causes a cyclic reference error when using the
# variables. There may be a way around this (see https://www.reddit.com/r/godot/comments/kimwxj/cyclic_reference_bug/)
# but it appears now to be an issue with GDScript types https://www.reddit.com/r/godot/comments/amy4wn/cyclic_dependencies_between_characters_and_maps/

var max_health:int = 5 setget set_max_health
var health:float = max_health setget set_health
var max_missiles:int = 3 setget set_max_missiles
var num_missiles:int = max_missiles setget set_num_missiles
var are_missiles_unlocked:bool = false setget set_missiles_unlocked

var screenshake_amount := 0.25
var screenshake_duration := 0.5

const MINIMUM_MAX_HEALTH = 1
const MINIMUM_HEALTH = 0
const MINIMUM_MAX_MISSILES = 0
const MINIMUM_MISSILES = 0

signal player_died
signal player_health_changed(amount)
signal max_health_changed(amount)
signal max_missiles_changed(amount)
signal player_missiles_changed(amount)
signal player_missiles_unlocked(value)

func set_health(value:float):
	if value == health:
		print("tried to set health to existing value")
		return

	if value < health:
		var multiplier:float = max_health / health
		Events.emit_signal("add_screenshake", 
			screenshake_amount * multiplier, 
			screenshake_duration * multiplier)
	
	health = clamp(value, MINIMUM_HEALTH, max_health)
	emit_signal("player_health_changed", health)
	if health == MINIMUM_HEALTH:
		emit_signal("player_died")

func set_max_health(value:int):
	if max_health == value:
		print("tried to set max health to existing value")
		return
	max_health = max(value, MINIMUM_MAX_HEALTH) as int
	emit_signal("max_health_changed", max_health)

func set_num_missiles(value:int):
	if num_missiles == value:
		print("tried to set num missiles to existing value")
		return
	num_missiles = clamp(value, MINIMUM_MISSILES, max_missiles) as int
	emit_signal("player_missiles_changed", num_missiles)

func set_max_missiles(value:int):
	if max_missiles == value:
		print("tried to set max missiles to existing value")
		return
	max_missiles = max(value, MINIMUM_MAX_MISSILES) as int
	emit_signal("max_missiles_changed", max_missiles)

func set_missiles_unlocked(value:bool):
	are_missiles_unlocked = value
	SaverAndLoader.custom_data.missiles_unlocked = value
	emit_signal("player_missiles_unlocked", are_missiles_unlocked)

func refil_stats():
	set_health(max_health)
	set_num_missiles(max_missiles)
