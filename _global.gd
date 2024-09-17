extends Node

const FONT_ATLAS_COLS = 32
const FONT_ATLAS_ROWS = 8

const BG_ATLAS_ID = {
	"ALL": 0
}

const FG_ATLAS_ID = {
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

var CGA_COLOR = {
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

var CGA_PALETTE = [
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
	Color(85, 255, 255),		# BRIGHT CYAN
	Color(255, 85, 85),		# BRIGHT RED
	Color(255, 85, 255),		# BRIGHT MAGENTA
	Color(255, 255, 85),		# BRIGHT BROWN
	Color(255, 255, 255)		# BRIGHT WHITE
]

var DOS_ANSI_CHARACTERS_DECIMAL = {
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

var DOS_ANSI_CHARACTERS_HEX = {
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

var UNICODE_ANSI_CHARACTERS_DECIMAL = {
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
var UNICODE_ANSI_CHARACTERS_HEX = {
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
