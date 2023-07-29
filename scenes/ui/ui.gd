extends CanvasLayer


@onready var score = $Score


func update_score():
	score.text = "امتیاز  " + str(Util.score)
