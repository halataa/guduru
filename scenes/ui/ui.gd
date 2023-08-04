extends CanvasLayer


@onready var score = $Score


func update_score():
	score.text = "امتیاز  " + str(Util.score)



func _on_pause_bottun_pressed():
	get_tree().paused = !get_tree().paused
