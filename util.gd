extends Node
const SAVE_PATH = 'user://data.save'


signal wrong_move(pos)
signal right_move
var score : int = 0
var high_score: int
var game_over : bool = false

func _ready():
	load_data()
	
func load_data():
	if FileAccess.file_exists(SAVE_PATH):
		print("file found")
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		high_score = file.get_var()
	else:
		print("file not found")
		high_score = 0

func save_data():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(score)
