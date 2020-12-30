extends WorldLevel

const PLAYER_BIT := 0

onready var bossEnemy = $BossEnemy
onready var blockedDoor = $BlockedDoor

func set_block_door(isActive:bool):
	blockedDoor.visible = isActive
	blockedDoor.set_collision_mask_bit(PLAYER_BIT, isActive)
	
func _ready():
	set_block_door(false)

func _on_Trigger_area_triggered():
	set_block_door(true)

func _on_BossEnemy_died():
	set_block_door(false)
