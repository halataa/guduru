extends Control

var enemy_template = preload("res://scripts/object_resource.gd")
var enemy_scene = preload("res://scenes/templates/object_template.tscn")

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
	var scene_save_path = "res://scenes/enemies/{0}.tscn"
	var save_path = "res://resources/{0}.tres"
	var obj_dir = "res://graphics/new_objects/"
	var fnames = dir_contents(obj_dir)
	for f in fnames:
		var obj_path = obj_dir + f
		var t = load(obj_path)
		var r = enemy_template.new(t, f.split('.')[0])
		ResourceSaver.save(r,save_path.format([f.split('.')[0]]))
		var enemy = enemy_scene.instantiate()
		enemy.meta = r
		enemy.get_ready()
		var new_scene = PackedScene.new()
		new_scene.pack(enemy)
		ResourceSaver.save(new_scene,scene_save_path.format([f.split('.')[0]]))
	print('DONE')
