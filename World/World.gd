extends Node
class_name MainWorld

var Main := ResourceLoader.MainInstances as MainInstances

onready var currentLevel:Node2D = $Level_00

func _ready():
	VisualServer.set_default_clear_color(Color.black)
	
	if SaverAndLoader.is_loading:
		SaverAndLoader.load_game()
		SaverAndLoader.is_loading = false
	
	var err = Main.Player.connect("hit_door", self, "_on_Player_hit_door")
	if err:
		print(err)

func _on_Player_hit_door(door:Door):
	if not door:
		return
	call_deferred("change_level", door)

func change_level(door:Door):
	var offset := currentLevel.position
	currentLevel.queue_free()
	
	# Add the level we are going to into the world
	var NewLevel := load(door.new_level_path) as PackedScene
	if not NewLevel:
		print("Could not load new level! Tried to load:", door.new_level_path)
		return
	var newLevel := NewLevel.instance() as Node2D
	add_child(newLevel)
	
	var targetDoor = get_door_with_connection(door, door.connection)
	if not targetDoor:
		print("Could not find a matching door to travel to!")
		return
	var exit_position := (targetDoor as Door).position - offset
	newLevel.position = door.position - exit_position

func get_door_with_connection(sourceDoor:Door, sourceConnection:Resource):
	var doors:Array = get_tree().get_nodes_in_group("Door")
	for door in doors:
		if door.connection == sourceConnection and door != sourceDoor:
			return door
	return null
