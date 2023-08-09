extends Node2D


@onready var name_text = $"..".meta.name
@onready var font = load("res://graphics/AnjomanMaxFN-Regular.ttf")
@export var font_size = 20
	
func _draw():
	font = FontFile.new()
	font.load_dynamic_font("res://graphics/AnjomanMaxFN-Regular.ttf")
	var s = font.get_string_size(name_text,HORIZONTAL_ALIGNMENT_CENTER,-1,font_size)
	var text_pos = Vector2(position.x - s.x/2, position.y+font_size/3)
	draw_string(font,text_pos,name_text,3,-1,font_size,Color(1,1,1),3,TextServer.DIRECTION_LTR)
