extends Node2D
class_name WorldLevel

func _ready():
	var parent = get_parent()
	if parent is MainWorld:
		parent.currentLevel = self

func save():
	var saveData = {
		SaverAndLoader.F_NAME: get_filename(),
		SaverAndLoader.PARENT: get_parent().get_path(),
		SaverAndLoader.POS_X: position.x,
		SaverAndLoader.POS_Y: position.y
	}
	return saveData
