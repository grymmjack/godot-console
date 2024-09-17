class_name TextConsole
extends Node2D

@export var rows:int = 25
@export var columns:int = 80
@export var background_color:int = G.CGA.BLACK
@export var foreground_color:int = G.CGA.WHITE
@export var cursor_position:Vector2i = Vector2i.ZERO
@export var foreground_tiles:TileMapLayer
@export var background_tiles:TileMapLayer

static var _fg_color:int = G.CGA.WHITE
static var _bg_color:int = G.CGA.BLACK
static var _x:int = 0
static var _y:int = 0
static var scrollback_buffer:Array[TextChar]

func _ready() -> void:
	color(foreground_color, background_color)
	cls()
	print_ruler()
	locate(10, 2)
	cecho("    Hello, World!    ", 14, 4)

# print a little ruler
func print_ruler() -> void:
	for y in range(rows):
		for x in range(columns):
			if y == 0:
				if x % 10 == 0:
					locate(x, y)
					echo(str(x))
		locate(0, y)
		echo(str(y))


# clear screen
func cls() -> void:
	for y in range(rows):
		for x in range(columns):
			bg(Vector2i(x, y), _bg_color)
	_set_cursor_position(Vector2i(0, 0))

# set foreground and background text colors
func color(fg_color:int, bg_color:int) -> void:
	foreground_color = fg_color
	background_color = bg_color

# set cursor position
func locate(x:int, y:int) -> void:
	_set_cursor_position(Vector2i(x, y))

# get cursor x position (column)
func pos(type:int = 0) -> int:
	match type:
		0:
			return cursor_position.x
		_:
			return cursor_position.x

# get cusor y position (row)
func csrlin() -> int:
	return cursor_position.y

# echo a string print using current colors
func echo(_str:String) -> void:
	var _position = cursor_position
	for i in len(_str):
		var cha:String = _str[i]
		var tile:Vector2i = cha_to_atlas_coord(cha)
		bg(Vector2i(_position.x+i, _position.y), _bg_color)
		fg(Vector2i(_position.x+i, _position.y), _fg_color, tile)
		_set_cursor_position(Vector2i(_position.x+i, _position.y))


# echo a string (synonymous with print, but prints in colors)
func cecho(_str:String, fg_color:int, bg_color:int) -> void:
	var _position = cursor_position
	for i in len(_str):
		var cha:String = _str[i]
		var tile:Vector2i = cha_to_atlas_coord(cha)
		bg(Vector2i(_position.x+i, _position.y), bg_color)
		fg(Vector2i(_position.x+i, _position.y), fg_color, tile)
		_set_cursor_position(Vector2i(_position.x+i, _position.y))

# set background color using %BG tilemap layer
func bg(_position:Vector2i, _color:int) -> void:
	%BG.set_cell(_position, G.BG_ATLAS_ID["ALL"], Vector2i(_color, 0))

# set a foreground colored cell using %FG tilemap layer
func fg(_position:Vector2i, _color:int, _tile:Vector2i) -> void:
	%FG.set_cell(_position, _color, _tile)

# map character to font atlas
func cha_to_atlas_coord(cha:String) -> Vector2i:
	var cha_ord:int = cha.unicode_at(0)
	var y:int = int(cha_ord / G.FONT_ATLAS_COLS)
	var x:int = int(cha_ord % G.FONT_ATLAS_COLS)
	return Vector2i(x, y)

# screen wrap update
func screen_wrap() -> void:
	if _y > rows:
		_y = rows
		screen_scroll_down()
	if _x > columns:
		_y += 1
		_x = 0

# scrolls screen_down
# TODO
func screen_scroll_down() -> void:
	var tiles:Array[Vector2i] = [ Vector2i.ZERO ]
	# move top row into memory
	# move top row+1 to top row-1 for entire tile row
	# loop until at row height


func _set_cursor_position(_position:Vector2i) -> void:
	cursor_position = _position
