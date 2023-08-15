extends CanvasLayer


@onready var score = $Score



func _process(delta):
	$ScreenSize.text = str(DisplayServer.screen_get_size())
	$WindowSize.text = str(DisplayServer.window_get_size())
	
	
func update_score():
	score.text = "امتیاز  " + str(Util.score)



func _on_pause_bottun_pressed():
	get_tree().paused = !get_tree().paused



func _on_eye_button_up():
	Input.action_release("reveal")


func _on_eye_button_down():
	Input.action_press("reveal")
