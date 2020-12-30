extends Area2D
class_name Hitbox
# Hitbox deals damage to hurtbox

export var damage = 1

func _on_Hitbox_area_entered(hurtbox : Hurtbox):
	if not hurtbox:
		print("Hitbox entered without being a hurtbox")
		return
	
	hurtbox.emit_signal("hit", damage)
