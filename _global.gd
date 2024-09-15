extends Node

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
