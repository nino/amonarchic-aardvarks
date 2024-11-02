extends CharacterBody2D

signal bumped

const SPEED = 400.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_active = false

func _walking_animation():
	if velocity.x != 0:
		$Pic.flip_h = velocity.x >= 0

	var time = Time.get_ticks_msec() / 1000.0
	var angle_offset = sin(time * 24.0) * 0.4
	
	# If we're walking, alternate between rotating 20degrees and -20degrees.
	if velocity.x != 0 || velocity.y != 0:
		$Pic.rotation = lerp_angle($Pic.rotation, 0.1 * sign(velocity.x) + angle_offset, 0.1)
	else:
		$Pic.rotation = lerp_angle($Pic.rotation, 0, 0.1)

func _update_debug_text():
	var active_string = "not active"
	if is_active:
		active_string = "active"
	$Label.text = "The " + name + " is " + active_string

func move_in_direction(x_direction: float, y_direction: float):
	if !is_active:
		return
		
	if y_direction:
		velocity.y = y_direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	if x_direction:
		velocity.x = x_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func perform_chestbump():
	if !is_active:
		return
		
	var nearby_character: CharacterBody2D
	for character in get_tree().get_nodes_in_group("Characters"):
		var dist = character.global_position.distance_to(global_position)
		if character != self and dist < 200:
			nearby_character = character
			break
			
	var animation = "chestbump_animation_left"
	if $Pic.flip_h:
		animation = "chestbump_animation"
	
	$Pic/PuffinAnimations.seek(0)
	$Pic/PuffinAnimations.play(animation)
	emit_signal("bumped")
	return nearby_character

func _physics_process(delta):
	if is_active:
		_walking_animation()

	_update_debug_text()
