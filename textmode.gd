class_name TextConsole
extends Node2D

@export var width:int = 80
@export var height:int = 25

static var _fg_color:int = G.CGA.WHITE
static var _bg_color:int = G.CGA.BLACK
static var _x:int = 0
static var _y:int = 0

func _ready() -> void:
	color(G.CGA.BRIGHT_WHITE, G.CGA.BLUE)
	cls()
	print_ruler()
	locate(10, 2)
	cecho("    Hello, World!    ", 14, 4)

# print a little ruler
func print_ruler() -> void:
	for y in range(height):
		for x in range(width):
			if y == 0:
				if x % 10 == 0:
					locate(x, y)
					echo(str(x))
		locate(0, y)
		echo(str(y))

# clear screen
func cls() -> void:
	for y in range(height):
		for x in range(width):
			bg(Vector2i(x, y), _bg_color)

# set default foreground and background text colors
func color(fg_color:int, bg_color:int) -> void:
	_fg_color = fg_color
	_bg_color = bg_color

# set cursor position
func locate(x:int, y:int) -> void:
	_x = x
	_y = y

# get cursor x position (column)
func pos(type:int = 0) -> int:
	match type:
		0:
			return _x
		_:
			return _x

# get cusor y position (row)
func csrlin() -> int:
	return _y

# echo a string print using current colors
func echo(_str:String) -> void:
	var _position = Vector2i(_x, _y)
	for i in len(_str):
		var cha:String = _str[i]
		var tile:Vector2i = cha_to_atlas_coord(cha)
		bg(Vector2i(_position.x+i, _position.y), _bg_color)
		fg(Vector2i(_position.x+i, _position.y), _fg_color, tile)


# echo a string (synonymous with print, but prints in colors)
func cecho(_str:String, fg_color:int, bg_color:int) -> void:
	var _position = Vector2i(_x, _y)
	for i in len(_str):
		var cha:String = _str[i]
		var tile:Vector2i = cha_to_atlas_coord(cha)
		bg(Vector2i(_position.x+i, _position.y), bg_color)
		fg(Vector2i(_position.x+i, _position.y), fg_color, tile)

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
