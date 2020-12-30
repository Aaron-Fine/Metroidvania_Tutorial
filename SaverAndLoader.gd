extends Node

const FILE_NAME := "user://savegame.save"

const F_NAME := "filename"
const POS_X := "position_x"
const POS_Y := "position_y"
const PARENT := "parent"

var is_loading := false

func save_game():
	var file := File.new()
	var err := file.open(FILE_NAME, File.WRITE)
	if err:
		print(err)
		print("Game not saved! Could not open file for writing!")
		return
	
	var persistNodes := get_tree().get_nodes_in_group("Persists")
	for node in persistNodes:
		var nodeData:Dictionary = node.save()
		file.store_line(to_json(nodeData))
	file.close()

func load_game():
	var file := File.new()
	if not file.file_exists(FILE_NAME):
		print("Game not loaded! ", FILE_NAME, " does not exist!")
		return
	
	var err := file.open(FILE_NAME, File.READ)
	if err:
		print(err)
		print("Game not loaded! Could not open file")
		return
	
	# Get rid of the existing nodes
	# Note: Parents must ensure their children are corectly loaded
	var persistNodes := get_tree().get_nodes_in_group("Persists")
	for node in persistNodes:
		node.queue_free()
	
	while not file.eof_reached():
		var lineFromFile := file.get_line()
		if lineFromFile.empty():
			continue
			
		var currentLine = parse_json(lineFromFile)
		if currentLine == null:
			print("Problem loading. Could not parse the following line:")
			print(lineFromFile)
			continue
		if typeof(currentLine) != TYPE_DICTIONARY:
			print("Problem loading. The following line is not a dictionary:")
			print(lineFromFile)
			continue
		
		# Enforce a schema on the records being read in
		# TODO: Implement this in a more flexible way
		if (not currentLine.has(F_NAME) 
		or not currentLine.has(POS_X)
		or not currentLine.has(POS_Y)
		or not currentLine.has(PARENT)):
			continue
		
		var newNode:Node2D = (load(currentLine[F_NAME]) as PackedScene).instance()
		if not newNode:
			continue
		newNode.position = Vector2(currentLine[POS_X], currentLine[POS_Y])
		get_node(currentLine[PARENT]).add_child(newNode, true)
		
		# TODO: Implement this such that we don't need the check
		for property in currentLine.keys():
			if (property == F_NAME
			or property == POS_X
			or property == POS_Y
			or property == PARENT):
				continue
			newNode.set(property, currentLine[property])
	file.close()
