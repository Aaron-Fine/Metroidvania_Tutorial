extends Resource
class_name MainInstances

# Note adding custom types here causes a cyclic reference error when using the
# variables. There may be a way around this (see https://www.reddit.com/r/godot/comments/kimwxj/cyclic_reference_bug/)
# but it appears now to be an issue with GDScript types
var Player = null
var WorldCamera = null
