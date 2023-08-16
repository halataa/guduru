extends Area2D


func _draw():
	var center = $GameoverHeight.position
	var start = center - Vector2.RIGHT * 400
	var end = center + Vector2.RIGHT * 400
	draw_line(start,end,Color(1,0,0),5)
