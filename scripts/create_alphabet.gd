extends Control

var stemplate:PackedScene = preload("res://scenes/templates/alphabet_template.tscn")
var png_path = "res://graphics/alphabet/"
var scene_path = "res://scenes/alphabet/{0}.tscn"

func dir_contents(path):
	var pngs = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			elif file_name.ends_with('.png'):
				pngs.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return pngs
	
func _ready():
	var rect = RectangleShape2D.new()
	rect.size = Vector2(96,96)
	var pngs = dir_contents(png_path)
	for p in pngs:
		var a = stemplate.instantiate()
		var png = load(png_path+p)
		var sprite = a.find_child('Image')
		var border = a.find_child('Border')
		border.texture = png
		border.scale = Vector2(0.85,0.85)
		border.visible = false
		sprite.texture = png
		sprite.scale = Vector2(0.75,0.75)
		a.find_child('Collision').shape = rect
		a.ord_num = p.split('.')[0].unicode_at(0)
		var new_scene = PackedScene.new()
		new_scene.pack(a)
		ResourceSaver.save(new_scene, scene_path.format([p.split('.')[0]]))
	print('DONE')
