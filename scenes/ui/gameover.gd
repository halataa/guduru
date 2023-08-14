extends CanvasLayer





func _on_button_pressed():
	Util.score = 0
	Util.game_over = false
	get_tree().paused = false
	get_tree().reload_current_scene()
