extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var chestbump_is_pressed = false

func _walking_animation():
	# Flip the sprite based on the direction.
	if velocity.x != 0:
		$PuffinSweaty.flip_h = velocity.x >= 0

	var time = Time.get_ticks_msec() / 1000.0
	var angle_offset = sin(time * 24.0) * 0.4
	
	# If he is walking, alternate between rotating 20degrees and -20degrees.
	if velocity.x != 0 || velocity.y != 0:
		$PuffinSweaty.rotation = lerp_angle($PuffinSweaty.rotation, 0.1 * sign(velocity.x) + angle_offset, 0.1)
	else:
		$PuffinSweaty.rotation = lerp_angle($PuffinSweaty.rotation, 0, 0.1)

func _chestbump():
	var animation = "chestbump_animation_left"
	if $PuffinSweaty.flip_h:
		animation = "chestbump_animation"
	if Input.is_key_pressed(KEY_Q):
		if chestbump_is_pressed == false:
			$PuffinSweaty/PuffinAnimations.seek(0)
			$PuffinSweaty/PuffinAnimations.play(animation)
		chestbump_is_pressed = true
	else:
		chestbump_is_pressed = false


func _physics_process(delta):
	_walking_animation()
	_chestbump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var x_direction = Input.get_axis("ui_left", "ui_right")
	var y_direction = Input.get_axis("ui_up", "ui_down")
	if y_direction:
		velocity.y = y_direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	if x_direction:
		velocity.x = x_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
