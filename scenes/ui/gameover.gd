extends CanvasLayer





func _on_button_pressed():
	Util.score = 0
	get_tree().reload_current_scene()
