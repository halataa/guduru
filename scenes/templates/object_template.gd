extends Area2D


@export var meta : enemy_object_resource
var rect = RectangleShape2D.new()



	
func _ready():
	add_to_group('enemies')

func get_ready():
	rect.size = Vector2(96,96)
	if meta:
		$Sprite2D.texture = meta.texture
		$Sprite2D.texture_filter = TEXTURE_FILTER_NEAREST
		$Sprite2D.scale = Vector2(3,3)
		$CollisionShape2D.shape = rect



func _on_body_entered(body):
	if body.is_contain:
		if body.ord_num in meta.letters:
			Util.right_move.emit()
			queue_free()
		else:
			Util.wrong_move.emit(position)
	else:
		if body.ord_num not in meta.letters:
			Util.right_move.emit()
			queue_free()
		else:
			Util.wrong_move.emit(position)
	body.queue_free()

