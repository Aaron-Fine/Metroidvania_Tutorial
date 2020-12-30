extends Area2D
class_name Door

# What other door do we connect with on the new level?
export(Resource) var connection = null
export(String, FILE, "*.tscn") var new_level_path = ""

var active := true

func _on_Door_body_entered(body:Player):
	if not body:
		return
		
	if active:
		body.emit_signal("hit_door", self)
		active = false
