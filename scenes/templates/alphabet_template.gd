extends CharacterBody2D


@export var offset: int = 100
@export var default_v_y = 100
@export var fast_v_y = 500


var window_size = DisplayServer.window_get_size()
@export var ord_num : int = 0

func _process(delta):
	var direction = 0
	if Input.is_action_just_pressed("right"):
		direction = 1
	elif Input.is_action_just_pressed("left"):
		direction = -1
	var new_position_x = position.x + direction * offset
	if new_position_x > 0 and new_position_x < window_size.x:
		position.x = new_position_x
	if Input.is_action_pressed("fast"):
		velocity.y = fast_v_y * delta
	else:
		velocity.y = default_v_y * delta 
		
	move_and_collide(velocity)
		

