extends Node2D


@onready var alphabet_scene_path = "res://scenes/alphabet/"
@onready var enemy_scene_path = "res://scenes/enemies/"
@onready var ascenes = dir_contents(alphabet_scene_path)
@onready var escenes = dir_contents(enemy_scene_path)
@onready var gameover = preload("res://scenes/ui/gameover.tscn")
@export var rand_limit_contain:float = 0.8

func height_offset():
	var vp = get_viewport().get_visible_rect().size
	return vp.y - 800



func dir_contents(path):
	var pngs = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			elif file_name.contains('.tscn'):
				if file_name.ends_with('.remap'):
					file_name = file_name.trim_suffix('.remap')
				pngs.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return pngs

func _ready():
	$EndOfScreen/End.global_position.y += height_offset()
	$EnemySpawnLocations.global_position.y += height_offset()
	$Gameover.visible = false
	$UI.update_score()
	Util.right_move.connect(_on_right_move)
	Util.wrong_move.connect(_on_wrong_move)
	var enemies = add_enemy_row()
	add_random_alphabet(enemies)

	
func _process(_delta):
	var enemies = $Enemies.get_children()
	if Input.is_action_pressed("reveal"):
		for e in enemies:
			e.find_child("Border").show()
			e.find_child("Sprite2D").hide()
	else:
		for e in enemies:
			e.find_child("Border").hide()
			e.find_child("Sprite2D").show()
		
	
func add_random_alphabet(enemies:Array=[]):
	var alist = []
	var choice
	if enemies:
		for e in enemies:
			for let in e.meta.letters:
				if let not in alist:
					alist.append(let)
		choice = alist.pick_random()
		choice = char(choice)
		choice = choice+'.tscn'
	else:
		choice = ascenes.pick_random()
	var spawn = $AlphabetSpawnLocations.get_children().pick_random()
	var a = load(alphabet_scene_path+choice).instantiate()
	var rand : float = rand_limit_contain
	rand = randf()
	var color:Color
	if rand > rand_limit_contain:
		a.is_contain = false
		color = Color(1,0,0)
	else:
		a.is_contain = true
		color = Color("#1bd165")
	a.position = spawn.global_position
	var border = a.find_child('Border')
	border.visible = true
	border.modulate = color
	$Alphabet.add_child.call_deferred(a)


func add_random_enemy(pos:Vector2):
	var choice = escenes.pick_random()
	var e = load(enemy_scene_path+choice).instantiate()
	e.global_position = pos
	$Enemies.add_child.call_deferred(e)


func add_enemy_row():
	var spawn = $EnemySpawnLocations.get_children()
	var enemies = []
	for s in spawn:
#		s.global_position.y = screen_size.y - 200
		var choice = escenes.pick_random()
		var e = load(enemy_scene_path+choice).instantiate()
		e.global_position = s.global_position
		$Enemies.add_child.call_deferred(e)
		enemies.append(e)
	return enemies

func get_4_enemies():
	var enemies = $Enemies.get_children()
	if not enemies:
		return []
	var col_1 = []
	var col_2 = []
	var col_3 = []	
	var col_4 = []
	var e4 = []
	for e in enemies:
		var x = e.position.x
		if x >=0 and x < 101:
			col_1.append(e)
		elif x >= 101 and x < 201:
			col_2.append(e)
		elif x >= 201 and x < 302:
			col_3.append(e)
		else:
			col_4.append(e)
	for c in [col_1,col_2,col_3,col_4]:
		if c:
			c.sort_custom(sort_y)
			e4.append(c[-1])
	return e4


func sort_y(a,b):
	if a.position.y > b.position.y:
		return true
	else:
		return false
	
		


func _on_alphabet_child_exiting_tree(_node):
	Input.action_release("fast")
	var enemies = get_4_enemies()
	if $Enemies.get_children() == []:
		enemies = add_enemy_row()
	add_random_alphabet(enemies)


func _on_enemy_cooldown_timeout():
	var children = $Enemies.get_children()
	for ch in children:
		ch.position += Vector2(0,-100)
	add_enemy_row()

func _on_wrong_move(pos):
	add_random_enemy(Vector2(pos.x,pos.y-100))

func _on_right_move():
	if !Util.game_over:
		Util.score += 1
		$UI.update_score()


func _on_end_of_screen_body_entered(body):
	add_random_enemy(Vector2(body.position.x,728))
	body.queue_free()



func _on_game_over_area_shape_entered(_area_rid, _area, _area_shape_index, _local_shape_index):
	get_tree().paused = true
	Util.game_over = true
	if Util.score > Util.high_score:
		Util.save_data()
		Util.high_score = Util.score
		$Gameover.find_child("Highscore").text = "رکورد جدید: " + str(Util.high_score)
	else:
		$Gameover.find_child("Highscore").text = "بیشترین امتیاز: " + str(Util.high_score)
	$Gameover.find_child("Score").text = "امتیاز شما: " + str(Util.score)
	$Gameover.show()
	
