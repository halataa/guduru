extends CharacterBody2D


@export var offset: int = 100
@export var default_v_y = 100
@export var fast_v_y = 500
@export var is_contain:bool = true

var window_size = DisplayServer.window_get_size()
@export var ord_num : int = 0

func _process(delta):
	var direction = 0
	if Input.is_action_just_pressed("right"):
		direction = 1
	elif Input.is_action_just_pressed("left"):
		direction = -1
	if !$LeftRay.is_colliding() and !$RightRay.is_colliding():
		move_alphabet(direction)
	if Input.is_action_pressed("fast"):
		velocity.y = fast_v_y * delta
	else:
		velocity.y = default_v_y * delta 
		
	move_and_collide(velocity)
		

func move_alphabet(direction):
	var new_position_x = position.x + direction * offset
	if new_position_x > 0 and new_position_x < window_size.x:
		position.x = new_position_x

func _on_touch_swiped(direction):
	move_alphabet(direction.x)
	if direction == Vector2.DOWN:
		Input.action_press('fast')
	

