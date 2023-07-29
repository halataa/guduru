extends Resource

class_name enemy_object_resource

@export var texture : Texture
@export var name: String
@export var letters : Array[int]


func _init(t=null,n=""):
	if t:
		texture = t
		name = n
		letters = get_letters(n)
	
func get_letters(n):
	for i in len(n):
		letters.append(n.unicode_at(i))
	return letters


