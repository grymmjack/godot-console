@icon("res://icon.svg")
class_name TextConsole
extends Node

signal is_ready
signal is_scrolling
signal is_printing
signal is_clearing
signal finished_clearing
signal cursor_moving
signal awaiting_input
signal color_changed
signal bg_color_changed
signal fg_color_changed
signal ansi_detected

@export_group("Screen")
@export var rows:int = 25
@export var columns:int = 80
@export var scrollback_size:int = 1000
@export_group("Colors")
@export var background_color:int = CGA.BLACK
@export var foreground_color:int = CGA.WHITE
@export_group("Cursor")
@export var cursor_position:Vector2i = Vector2i.ZERO
@export var cursor_visibile:bool = true
@export_enum("UNDERLINE", "SOLID", "BOX") var cursor_shape:int
@export_group("TileMapLayers")
@export var background:TileMapLayer
@export var foreground:TileMapLayer

static var _scrollback_buffer:Array[TextChar]

enum VERTICAL_DIRECTION { DOWN, UP }
enum HORIZONTAL_DIRECTION { LEFT, RIGHT }

const FONT_ATLAS_COLS := 32
const FONT_ATLAS_ROWS := 8
const BASE_FONT_TEXTURE:Texture2D = preload("res://assets/Perfect DOS VGA 437_2.png")
const BASE_TILESET:TileSet = preload("res://assets/DOSFont-BASE.tres")
const BASE_TILE_SIZE:Vector2i = Vector2i(8, 16)
const TARGET_PATH:String = "res://assets"
const BG_ATLAS_ID := 0
const FG_ATLAS_ID := 0

var CGA_COLOR := {
	"BLACK": 0,
	"BLUE": 1,
	"GREEN": 2,
	"CYAN": 3,
	"RED": 4,
	"MAGENTA": 5 ,
	"BROWN": 6,
	"WHITE": 7,
	"GRAY": 8,
	"BRIGHT_BLUE": 9,
	"BRIGHT_GREEN": 10,
	"BRIGHT_CYAN": 11,
	"BRIGHT_RED": 12,
	"BRIGHT_MAGENTA": 13,
	"BRIGHT_BROWN": 14,
	"BRIGHT_WHITE": 15
}

enum CGA {
	BLACK,
	BLUE,
	GREEN,
	CYAN,
	RED,
	MAGENTA,
	BROWN,
	WHITE,
	GRAY,
	BRIGHT_BLUE,
	BRIGHT_GREEN,
	BRIGHT_CYAN,
	BRIGHT_RED,
	BRIGHT_MAGENTA,
	BRIGHT_BROWN,
	BRIGHT_WHITE
}

var CGA_PALETTE := [
	Color(0, 0, 0),			# BLACK
	Color(0, 0, 170),		# BLUE
	Color(0, 170, 0),		# GREEN
	Color(0, 170, 170),		# CYAN
	Color(170, 0, 0),		# RED
	Color(170, 0, 170),		# MAGENTA
	Color(170, 85, 0),		# BROWN
	Color(170, 170, 170),	# WHITE
	Color(85, 85, 85),		# GRAY
	Color(85, 85, 255),		# BRIGHT BLUE
	Color(85, 255, 85),		# BRIGHT GREEN
	Color(85, 255, 255),	# BRIGHT CYAN
	Color(255, 85, 85),		# BRIGHT RED
	Color(255, 85, 255),	# BRIGHT MAGENTA
	Color(255, 255, 85),	# BRIGHT BROWN
	Color(255, 255, 255)	# BRIGHT WHITE
]

var CGA_MODULATED := [
	Color(0, 0, 0),			# BLACK
	Color(0, 0, 0.66),		# BLUE
	Color(0, 0.66, 0),		# GREEN
	Color(0, 0.66, 0.66),	# CYAN
	Color(0.66, 0, 0),		# RED
	Color(0.66, 0, 0.66),	# MAGENTA
	Color(0.66, 0.33, 0),	# BROWN
	Color(0.66, 0.66, 0.66),# WHITE
	Color(0.33, 0.33, 0.33),# GRAY
	Color(0.33, 0.33, 1.0),	# BRIGHT BLUE
	Color(0.33, 1.0, 0.33),	# BRIGHT GREEN
	Color(0.33, 1.0, 1.0),	# BRIGHT CYAN
	Color(1.0, 0.33, 0.33),	# BRIGHT RED
	Color(1.0, 0.33, 1.0),	# BRIGHT MAGENTA
	Color(1.0, 1.0, 0.33),	# BRIGHT BROWN
	Color(1.0, 1.0, 1.0)	# BRIGHT WHITE
]

var DOS_ANSI_CHARACTERS_DECIMAL := {
	"F1": 176,	# ░
	"F2": 177,	# ▒
	"F3": 178,	# ▓
	"F4": 219,	# █
	"F5": 223,	# ▀
	"F6": 220,	# ▄
	"F7": 221,	# ▌
	"F8": 222,	# ▐
	"F9": 254,	# ■
	"F10": 249	# ·
}

var DOS_ANSI_CHARACTERS_HEX := {
	"F1": 0x00B0,	# ░
	"F2": 0x00B1,	# ▒
	"F3": 0x00B2,	# ▓
	"F4": 0x00DB,	# █
	"F5": 0x00DF,	# ▀
	"F6": 0x00DC,	# ▄
	"F7": 0x00DD,	# ▌
	"F8": 0x00DE,	# ▐
	"F9": 0x00FE,	# ■
	"F10": 0x00F9	# ·
}

var UNICODE_ANSI_CHARACTERS_DECIMAL := {
	"F1": 9617,	# ░
	"F2": 9618,	# ▒
	"F3": 9619,	# ▓
	"F4": 9608,	# █
	"F5": 9600,	# ▀
	"F6": 9604,	# ▄
	"F7": 9612,	# ▌
	"F8": 9616,	# ▐
	"F9": 9632,	# ■
	"F10": 183	# ·
}

# to insert unicode use: CTRL+SHIFT+u - then type hex number - then space to insert
var UNICODE_ANSI_CHARACTERS_HEX := {
	"F1": 0x2591,	# ░
	"F2": 0x2592,	# ▒
	"F3": 0x2593,	# ▓
	"F4": 0x2588,	# █
	"F5": 0x2580,	# ▀
	"F6": 0x2584,	# ▄
	"F7": 0x258C,	# ▌
	"F8": 0x2590,	# ▐
	"F9": 0x25A0,	# ■
	"F10": 0x00B7	# ·
}

# from https://github.com/SelinaDev/Godot-4-ASCII-Grid/blob/0ad3a145f3b296cd474e3619b43ca1128c6a309d/addons/ascii_grid/term_cell.gd#L7
var UNICODE_ASCII := { "": 0, "☺": 1, "☻": 2, "♥": 3, "♦": 4, "♣": 5, "♠": 6, "•": 7, "◘": 8, "○": 9, "◙": 10, "♂": 11, "♀": 12, "♪": 13, "♫": 14, "☼": 15, "►": 16, "◄": 17, "↕": 18, "‼": 19, "¶": 20, "§": 21, "▬": 22, "↨": 23, "↑": 24, "↓": 25, "→": 26, "←": 27, "∟": 28, "↔": 29, "▲": 30, "▼": 31, " ": 32, "!": 33, "\"": 34, "#": 35, "$": 36, "%": 37, "&": 38, "\'": 39, "(": 40, ")": 41, "*": 42, "+": 43, ",": 44, "-": 45, ".": 46, "/": 47, "0": 48, "1": 49, "2": 50, "3": 51, "4": 52, "5": 53, "6": 54, "7": 55, "8": 56, "9": 57, ":": 58, ";": 59, "<": 60, "=": 61, ">": 62, "?": 63, "@": 64, "A": 65, "B": 66, "C": 67, "D": 68, "E": 69, "F": 70, "G": 71, "H": 72, "I": 73, "J": 74, "K": 75, "L": 76, "M": 77, "N": 78, "O": 79, "P": 80, "Q": 81, "R": 82, "S": 83, "T": 84, "U": 85, "V": 86, "W": 87, "X": 88, "Y": 89, "Z": 90, "[": 91, "\\": 92, "]": 93, "^": 94, "_": 95, "`": 96, "a": 97, "b": 98, "c": 99, "d": 100, "e": 101, "f": 102, "g": 103, "h": 104, "i": 105, "j": 106, "k": 107, "l": 108, "m": 109, "n": 110, "o": 111, "p": 112, "q": 113, "r": 114, "s": 115, "t": 116, "u": 117, "v": 118, "w": 119, "x": 120, "y": 121, "z": 122, "{": 123, "|": 124, "}": 125, "~": 126, "⌂": 127, "Ç": 128, "ü": 129, "é": 130, "â": 131, "ä": 132, "à": 133, "å": 134, "ç": 135, "ê": 136, "ë": 137, "è": 138, "ï": 139, "î": 140, "ì": 141, "Ä": 142, "Å": 143, "É": 144, "æ": 145, "Æ": 146, "ô": 147, "ö": 148, "ò": 149, "û": 150, "ù": 151, "ÿ": 152, "Ö": 153, "Ü": 154, "¢": 155, "£": 156, "¥": 157, "₧": 158, "ƒ": 159, "á": 160, "í": 161, "ó": 162, "ú": 163, "ñ": 164, "Ñ": 165, "ª": 166, "º": 167, "¿": 168, "⌐": 169, "¬": 170, "½": 171, "¼": 172, "¡": 173, "«": 174, "»": 175, "░": 176, "▒": 177, "▓": 178, "│": 179, "┤": 180, "╡": 181, "╢": 182, "╖": 183, "╕": 184, "╣": 185, "║": 186, "╗": 187, "╝": 188, "╜": 189, "╛": 190, "┐": 191, "└": 192, "┴": 193, "┬": 194, "├": 195, "─": 196, "┼": 197, "╞": 198, "╟": 199, "╚": 200, "╔": 201, "╩": 202, "╦": 203, "╠": 204, "═": 205, "╬": 206, "╧": 207, "╨": 208, "╤": 209, "╥": 210, "╙": 211, "╘": 212, "╒": 213, "╓": 214, "╫": 215, "╪": 216, "┘": 217, "┌": 218, "█": 219, "▄": 220, "▌": 221, "▐": 222, "▀": 223, "α": 224, "ß": 225, "Γ": 226, "π": 227, "Σ": 228, "σ": 229, "µ": 230, "τ": 231, "Φ": 232, "Θ": 233, "Ω": 234, "δ": 235, "∞": 236, "φ": 237, "ε": 238, "∩": 239, "≡": 240, "±": 241, "≥": 242, "≤": 243, "⌠": 244, "⌡": 245, "÷": 246, "≈": 247, "°": 248, "∙": 249, "·": 250, "√": 251, "ⁿ": 252, "²": 253, "■": 254, " ": 255 }
var ASCII_UNICODE := [ "", "☺", "☻", "♥", "♦", "♣", "♠", "•", "◘", "○", "◙", "♂", "♀", "♪", "♫", "☼", "►", "◄", "↕", "‼", "¶", "§", "▬", "↨", "↑", "↓", "→", "←", "∟", "↔", "▲", "▼", " ", "!", "\"", "#", "$", "%", "&", "\'", "(", ")", "*", "+", ",", "-", ".", "/", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ":", ";", "<", "=", ">", "?", "@", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "[", "\\", "]", "^", "_", "`", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "{", "|", "}", "~", "⌂", "Ç", "ü", "é", "â", "ä", "à", "å", "ç", "ê", "ë", "è", "ï", "î", "ì", "Ä", "Å", "É", "æ", "Æ", "ô", "ö", "ò", "û", "ù", "ÿ", "Ö", "Ü", "¢", "£", "¥", "₧", "ƒ", "á", "í", "ó", "ú", "ñ", "Ñ", "ª", "º", "¿", "⌐", "¬", "½", "¼", "¡", "«", "»", "░", "▒", "▓", "│", "┤", "╡", "╢", "╖", "╕", "╣", "║", "╗", "╝", "╜", "╛", "┐", "└", "┴", "┬", "├", "─", "┼", "╞", "╟", "╚", "╔", "╩", "╦", "╠", "═", "╬", "╧", "╨", "╤", "╥", "╙", "╘", "╒", "╓", "╫", "╪", "┘", "┌", "█", "▄", "▌", "▐", "▀", "α", "ß", "Γ", "π", "Σ", "σ", "µ", "τ", "Φ", "Θ", "Ω", "δ", "∞", "φ", "ε", "∩", "≡", "±", "≥", "≤", "⌠", "⌡", "÷", "≈", "°", "∙", "·", "√", "ⁿ", "²", "■", " " ]

func _ready() -> void:
	is_ready.emit()

# clear screen
func cls() -> void:
	is_clearing.emit()
	for y in range(rows):
		for x in range(columns):
			bg(Vector2i(x, y), background_color)
	_set_cursor_position(Vector2i(0, 0))
	finished_clearing.emit()

# set foreground and background text colors
func color(fg_color:int, bg_color:int) -> void:
	color_changed.emit(fg_color, bg_color)
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
	is_printing.emit(_str)
	for i in len(_str):
		var cha:String = _str[i]
		var tile:Vector2i = cha_to_atlas_coord(cha)
		bg(Vector2i(cursor_position.x, cursor_position.y), background_color)
		fg(Vector2i(cursor_position.x, cursor_position.y), foreground_color, tile)
		var new_x:int = cursor_position.x + 1
		var new_y:int = cursor_position.y
		locate(new_x, new_y)

# echo a string (synonymous with print, but prints in colors)
func cecho(_str:String, fg_color:int, bg_color:int) -> void:
	is_printing.emit(_str)
	for i in len(_str):
		var cha:String = _str[i]
		var tile:Vector2i = cha_to_atlas_coord(cha)
		bg(Vector2i(cursor_position.x, cursor_position.y), bg_color)
		fg(Vector2i(cursor_position.x, cursor_position.y), fg_color, tile)
		var new_x:int = cursor_position.x + 1
		var new_y:int = cursor_position.y
		locate(new_x, new_y)

# set background color using %BG tilemap layer
func bg(_position:Vector2i, _color:int) -> void:
	color_changed.emit()
	bg_color_changed.emit()
	%BG.set_cell(_position, BG_ATLAS_ID, Vector2i(_color, 0))

# set a foreground colored cell using %FG tilemap layer
func fg(_position:Vector2i, _color:int, _tile:Vector2i) -> void:
	color_changed.emit()
	fg_color_changed.emit()
	#set_cell(coords: Vector2i, source_id: int = -1, atlas_coords: Vector2i = Vector2i(-1, -1), alternative_tile: int = 0)
	var alternative_tile:int = _color + CGA_PALETTE.size()
	var source_id:int = FG_ATLAS_ID
	%FG.set_cell(_position, source_id, _tile, alternative_tile)

# map character to font atlas
func cha_to_atlas_coord(cha:String) -> Vector2i:
	var cha_ord:int = ASCII_UNICODE.find(cha) if cha in ASCII_UNICODE else cha.unicode_at(0)
	if cha_ord == 27:
		ansi_detected.emit()
	@warning_ignore("integer_division")
	var y:int = int(cha_ord / FONT_ATLAS_COLS)
	var x:int = int(cha_ord % FONT_ATLAS_COLS)
	return Vector2i(x, y)

# screen wrap update
func screen_wrap() -> void:
	if cursor_position.y >= rows:
		cursor_position.y = rows
		screen_scroll_down()
	if cursor_position.x >= columns:
		cursor_position.y += 1
		cursor_position.x = 0

func _set_cursor_position(_position:Vector2i) -> void:
	cursor_moving.emit(_position, cursor_position)
	cursor_position = _position
	screen_wrap()

# TODO
func screen_scroll_down() -> void:
	is_scrolling.emit(VERTICAL_DIRECTION.DOWN)
	# move top row into memory
	# move top row+1 to top row-1 for entire tile row
	# loop until at row height

# TODO
func screen_scroll_up() -> void:
	is_scrolling.emit(VERTICAL_DIRECTION.UP)

# TODO
func input(prompt:String) -> String:
	awaiting_input.emit()
	return ""

# TODO
func inkey() -> String:
	awaiting_input.emit()
	return ""

# Create colored tile alternates
# thank you to Selina - https://github.com/SelinaDev/
func create_colored_tiles(colors, base_tileset:TileSet, font_name:String, palette_name:String) -> void:
	var tileset:TileSet = base_tileset.duplicate(true)
	var tileset_source:TileSetAtlasSource = tileset.get_source(0)
	var grid_size:Vector2i = tileset_source.get_atlas_grid_size()
	var total_colors:int = colors.size()
	for c:int in range(0, total_colors):
		tileset.resource_name = font_name
		tileset_source.resource_name = palette_name
		var _color:Color = colors[c]
		print(colors[c])
		for y:int in range(grid_size.y):
			for x:int in range(grid_size.x):
				var id:int = tileset_source.create_alternative_tile(Vector2i(x, y), c + total_colors)
				var colored_tile_data:TileData = tileset_source.get_tile_data(Vector2i(x, y), id)
				colored_tile_data.modulate.r8 = colors[c].r
				colored_tile_data.modulate.g8 = colors[c].g
				colored_tile_data.modulate.b8 = colors[c].b
		print("Created alternative tileset for COLOR %d" % [ c ])
	var filename:String =  TARGET_PATH + "/DOSFont-%s.tres" % palette_name
	ResourceSaver.save(tileset, filename)
	print("Created %s" % filename)
