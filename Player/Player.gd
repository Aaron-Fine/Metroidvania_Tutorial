extends KinematicBody2D
class_name Player

const DustEffect = preload("res://Effects/DustEffect.tscn")
const WallDustEffect = preload("res://Effects/WallDustEffect.tscn")
const PlayerBullet = preload("res://Player/PlayerBullet.tscn")
const PlayerMissile = preload("res://Player/PlayerMissile.tscn")
const JumpEffect = preload("res://Effects/JumpEffect.tscn")

var Stats := ResourceLoader.PlayerStats as PlayerStats
var Main := ResourceLoader.MainInstances as MainInstances

export var ACCELERATION := 512
export var MAX_SPEED := 64
export var WALL_SLIDE_SPEED := 25
export var MAX_WALL_SLIDE_SPEED := 128
export var FRICTION := 0.25
export var GRAVITY := 200
export var GRAVITY_DIRECTION := Vector2.UP
export var JUMP_FORCE := 128
export var WALL_JUMP_FORCE_MULTIPLIER := 0.8
export var DOUBLE_JUMP_MULTIPLIER := 0.75
export var MAX_SLOPE_ANGLE := 46
export var BULLET_SPEED := 250
export var MISSILE_SPEED := 150
export var MISSILE_KNOCKBACK_MULTIPLIER := 0.25

enum {
	MOVE,
	WALL_SLIDE
}

var invincible = false setget set_invincible
var state := MOVE
var motion_vector := Vector2.ZERO
var input_vector := Vector2.ZERO
var snap_vector := Vector2.DOWN
var is_jumping := false
var is_doulbe_jump_ready := true

onready var sprite := $Sprite as Sprite
onready var spriteAnimator := $SpriteAnimator as AnimationPlayer
onready var coyoteJumpTimer := $CoyoteJumpTimer as Timer
onready var gun := $Sprite/PlayerGun as PlayerGun
onready var muzzle := $Sprite/PlayerGun/Muzzle as Position2D
onready var fireCooldown := $FireCooldownTimer as Timer
onready var blinkAnimator := $BlinkAnimator as AnimationPlayer
onready var powerupDetector := $PowerupDetector as Area2D

# warning-ignore:unused_signal
signal hit_door(door)

func save():
	var saveData = {
		SaverAndLoader.F_NAME: get_filename(),
		SaverAndLoader.PARENT: get_parent().get_path(),
		SaverAndLoader.POS_X: position.x,
		SaverAndLoader.POS_Y: position.y
	}
	return saveData

func set_invincible(value):
	invincible = value

func _ready():
	assert(Stats, "Player Stats object must be accesable by the Player")
	assert(Main, "Main Instances object must be accesable by the Player")
	
	var err = Stats.connect("player_died", self, "_on_died")
	if err:
		print(err)

	Main.Player = self
	call_deferred("assign_world_camera")

func assign_world_camera():
	assert(Main.WorldCamera, "Player must have access to a valid Main.WorldCamera")
	var follow := RemoteTransform2D.new()
	follow.remote_path = (Main.WorldCamera as Camera2D).get_path()
	add_child(follow)

func queue_free():
	Main.Player = null
	.queue_free()

func _physics_process(delta:float):
	is_jumping = false
	
	match state:
		MOVE:
			get_input_vector()
			apply_horizontal_force(delta)
			apply_friction()
			update_snap_vector()
			jump_check()
			apply_gravity(delta)
			update_animations()
			wallslide_check()
			
		WALL_SLIDE:
			spriteAnimator.play("Wall Slide")
			
			var wall_axis := get_wall_axis()
			if wall_axis != 0:
				sprite.scale.x = wall_axis
			
			wall_slide_jump_check(wall_axis)
			wall_slide_fast_slide_check(delta)
			wall_slide_detach_check(delta, wall_axis)
			
			if is_on_floor():
				state = MOVE
			
	move_player()
	
	if Input.is_action_pressed("fire") and fireCooldown.time_left <= 0:
		fire_bullet()
	if Input.is_action_pressed("fire_missile") and fireCooldown.time_left <= 0:
		fire_missile()
	if Input.is_action_just_pressed("save"):
		SaverAndLoader.save_game()
	if Input.is_action_just_pressed("load"):
		SaverAndLoader.load_game()

func projectile_setup(scene:PackedScene, speed:int) -> Projectile:
	if not scene or not speed:
		return Node2D.instance()
	
	var projectile := Utils.instance_scene_on_main(scene, muzzle.global_position) as Projectile
	if not projectile:
		return Node2D.instance()
	
	projectile.velocity = Vector2.RIGHT.rotated(gun.rotation) * speed
	projectile.velocity.x *= sprite.scale.x
	projectile.rotation = projectile.velocity.angle()
	return projectile

func fire_bullet():
# warning-ignore:return_value_discarded
	projectile_setup(PlayerBullet, BULLET_SPEED)
	fireCooldown.start()

func fire_missile():
	if Stats.num_missiles > 0 and Stats.are_missiles_unlocked:
		var missile := projectile_setup(PlayerMissile, MISSILE_SPEED)
		motion_vector -= missile.velocity * MISSILE_KNOCKBACK_MULTIPLIER
		fireCooldown.start()
		Stats.num_missiles -= 1

func create_dust_effect():
	var dust_pos := global_position
	dust_pos.x += rand_range(-4, 4)
	
# warning-ignore:return_value_discarded
	Utils.instance_scene_on_main(DustEffect, dust_pos)

func get_input_vector():
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

func apply_horizontal_force(delta:float):
	if input_vector.x != 0:
		motion_vector.x += input_vector.x * ACCELERATION * delta
		motion_vector.x = clamp(motion_vector.x, -MAX_SPEED, MAX_SPEED)

func apply_friction():
	if input_vector.x == 0 and is_on_floor():
		motion_vector.x = lerp(motion_vector.x, 0, FRICTION)

func apply_gravity(delta:float):
	if !is_on_floor():
		motion_vector.y += GRAVITY * delta
		motion_vector.y = min(motion_vector.y, JUMP_FORCE)

func update_snap_vector():
	if is_on_floor():
		snap_vector = Vector2.DOWN

func jump_check():
	if is_on_floor() or coyoteJumpTimer.time_left > 0:
		if Input.is_action_just_pressed("ui_up"):
			jump(JUMP_FORCE)
			is_jumping = true
	elif Input.is_action_just_released("ui_up") and motion_vector.y < -JUMP_FORCE / 2.0:
		motion_vector.y = -JUMP_FORCE / 2.0
		
	elif Input.is_action_just_pressed("ui_up") and is_doulbe_jump_ready:
		jump(JUMP_FORCE * DOUBLE_JUMP_MULTIPLIER)
		is_doulbe_jump_ready = false

func jump(force):
# warning-ignore:return_value_discarded
	Utils.instance_scene_on_main(JumpEffect, global_position)
	motion_vector.y = -force
	snap_vector = Vector2.ZERO

func update_animations():
	var facing := sign(get_local_mouse_position().x)
	if facing != 0:
		sprite.scale.x = facing
	
	if input_vector.x != 0:
		spriteAnimator.play("Run")
		spriteAnimator.playback_speed = sign(input_vector.x) * sign(sprite.scale.x)
	else:
		spriteAnimator.play("Idle")
		spriteAnimator.playback_speed = 1
	
	if !is_on_floor():
		spriteAnimator.play("Jump")

func move_player():
	var started_on_floor := is_on_floor()
	var started_in_air := not is_on_floor()
	var starting_position := position
	var starting_motion := motion_vector
	
	var stop_on_slope := true
	var max_slides := 4
	motion_vector = move_and_slide_with_snap(motion_vector, 
											 snap_vector * 4, 
											 GRAVITY_DIRECTION, 
											 stop_on_slope, 
											 max_slides, 
											 deg2rad(MAX_SLOPE_ANGLE))
	
	# landing
	if started_in_air and is_on_floor():
		# Prevent loosing momentum from landing on a slope
		motion_vector.x = starting_motion.x
# warning-ignore:return_value_discarded
		Utils.instance_scene_on_main(JumpEffect, global_position)
		is_doulbe_jump_ready = true
	
	# just left ground
	if started_on_floor and !is_on_floor() and !is_jumping:
		# We fell off a ledge. There can sometimes be residual
		# downward motion from the move_and_slide_with_snap that
		# needs to be removed if we just went up a slope
		motion_vector.y = 0
		position.y = starting_position.y
		coyoteJumpTimer.start()
	
	if is_on_floor() and get_floor_velocity().length() == 0 and abs(motion_vector.x) < 1:
		# hack to prevent sliding down a slope that we should be
		# able to stand on. NOTE: this prevents sloped moving platforms!
		# If move_and_slide_with_snap gets fixed this can be removed
		position.x = starting_position.x

func _on_Hurtbox_hit(damageDone:int):
	if not invincible:
		Stats.health -= damageDone
		blinkAnimator.play("Blink")

func wallslide_check():
	if not is_on_floor() and is_on_wall():
		state = WALL_SLIDE
		is_doulbe_jump_ready = true
		create_dust_effect()

func get_wall_axis() -> int:
	var is_right_wall = test_move(transform, Vector2.RIGHT)
	var is_left_wall = test_move(transform, Vector2.LEFT)
	return int(is_left_wall) - int(is_right_wall)

func create_wall_jump_effect(wall_axis:int):
	var dust_pos := global_position + Vector2(wall_axis * 4, -2)
	var effect := Utils.instance_scene_on_main(WallDustEffect, dust_pos)
	effect.scale.x = wall_axis

func wall_slide_jump_check(wall_axis:int):
	if Input.is_action_just_pressed("ui_up"):
		motion_vector.x = wall_axis * MAX_SPEED
		motion_vector.y = -JUMP_FORCE * WALL_JUMP_FORCE_MULTIPLIER
		state = MOVE
		create_wall_jump_effect(wall_axis)

func wall_slide_fast_slide_check(delta:float):
	var slide_speed = WALL_SLIDE_SPEED
	if Input.is_action_pressed("ui_down"):
		slide_speed = MAX_WALL_SLIDE_SPEED
	
	motion_vector.y = min(motion_vector.y + GRAVITY * delta, slide_speed)

func wall_slide_detach_check(delta:float, wall_axis:int):
	if Input.is_action_just_pressed("ui_right"):
		motion_vector.x = ACCELERATION * delta
		state = MOVE
	
	elif Input.is_action_just_pressed("ui_left"):
		motion_vector.x = -ACCELERATION * delta
		state = MOVE
	
	elif wall_axis == 0:
		state = MOVE

func _on_PowerupDetector_area_entered(area:Powerup):
	if not area:
		return
	
	area._pickup()

func _on_died():
	queue_free()
