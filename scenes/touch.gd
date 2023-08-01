extends Node

signal swiped(direction)
signal swiped_calceled(start_position)


@export var MAX_DIAGONAL_SLOPE = 1.3
var swipe_start_position = Vector2()
@onready var timer = $Timer

func _input(event):
	if not event is InputEventScreenTouch:
		return
	if event.is_pressed():
		_start_detection(event.position)
	elif not timer.is_stopped():
		_end_detection(event.position)
	
		
		

func _start_detection(position):
	swipe_start_position = position
	timer.start()
	
func _end_detection(positoin):
	timer.stop()
	var direction = (positoin - swipe_start_position).normalized()
	if abs(direction.x) + abs(direction.y) >= MAX_DIAGONAL_SLOPE:
		return
	if abs(direction.x) > abs(direction.y):
		swiped.emit(Vector2(sign(direction.x),0))
	if abs(direction.y) > abs(direction.x):
		swiped.emit(Vector2(0,sign(direction.y)))


func _on_timer_timeout():
	swiped_calceled.emit(swipe_start_position)
