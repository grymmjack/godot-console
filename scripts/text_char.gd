class_name TextChar
extends Resource

@export var screen_position:Vector2i = Vector2i.ZERO:
	set(_position):
		screen_position = _position
	get():
		return screen_position

@export var atlas_position:Vector2i = Vector2i.ZERO:
	set(_position):
		atlas_position = _position
	get():
		return atlas_position

@export var fg_color:int = 7:
	set(_color):
		fg_color = _color
	get():
		return fg_color

@export var bg_color:int = 0:
	set(_color):
		bg_color = _color
	get():
		return bg_color
