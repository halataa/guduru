extends Node2D


var alphabet_scene_path = "res://scenes/alphabet/"
var enemy_scene_path = "res://scenes/enemies/"
var ascenes = dir_contents(alphabet_scene_path)
var escenes = dir_contents(enemy_scene_path)

func dir_contents(path):
	var pngs = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			elif file_name.ends_with('.tscn'):
				pngs.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return pngs

func _ready():
	$UI.update_score()
	Util.right_move.connect(_on_right_move)
	Util.wrong_move.connect(_on_wrong_move)
	var enemies = add_enemy_row()
	add_random_alphabet(enemies)

	
func _process(_delta):
	pass
		
	
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
	a.position = spawn.global_position
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
	Util.active_enemies = e4
	return e4


func sort_y(a,b):
	if a.position.y > b.position.y:
		return true
	else:
		return false
	
		


func _on_alphabet_child_exiting_tree(_node):
	var enemies = get_4_enemies()
	add_random_alphabet(enemies)


func _on_enemy_cooldown_timeout():
	var children = $Enemies.get_children()
	for ch in children:
		ch.position += Vector2(0,-100)
	add_enemy_row()

func _on_wrong_move(pos):
	add_random_enemy(Vector2(pos.x,pos.y-100))

func _on_right_move():
	Util.score += 1
	$UI.update_score()


func _on_end_of_screen_body_entered(body):
	add_random_enemy(Vector2(body.position.x,728))
	body.queue_free()



func _on_game_over_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	print('GAMEOVER')
	
