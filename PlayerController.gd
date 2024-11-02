extends Node

@export var default_character_path: NodePath
var controlled_character: CharacterBody2D
var chestbump_is_pressed = false

func _ready():
	if default_character_path:
		var default_character = get_node(default_character_path)
		switch_control_to(default_character)

func _physics_process(_delta: float):
	if !controlled_character:
		return
		
	var x_direction = Input.get_axis("ui_left", "ui_right")
	var y_direction = Input.get_axis("ui_up", "ui_down")
	controlled_character.move_in_direction(x_direction, y_direction)
	
	if Input.is_key_pressed(KEY_Q):
		if !chestbump_is_pressed:
			var next_active = controlled_character.perform_chestbump()
			if next_active:
				switch_control_to(next_active)
		chestbump_is_pressed = true
	else:
		chestbump_is_pressed = false

func switch_control_to(character: CharacterBody2D):
	if controlled_character:
		controlled_character.is_active = false
	character.is_active = true
	controlled_character = character
