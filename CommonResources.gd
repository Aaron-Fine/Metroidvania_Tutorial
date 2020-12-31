extends Node

# Note adding custom types here causes a cyclic reference error when using the
# variables. There may be a way around this (see https://www.reddit.com/r/godot/comments/kimwxj/cyclic_reference_bug/)
# but it appears now to be an issue with GDScript types

var PlayerStats = preload("res://Player/PlayerStats.tres")
var MainInstances = preload("res://MainInstances.tres")
