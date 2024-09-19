@icon("res://icon.svg")
class_name TextScreen
extends TextConsole

func _ready() -> void:
	#create_colored_tiles(CGA_PALETTE, BASE_TILESET, BASE_FONT_TEXTURE, "DOS 8x16", "CGA")
	color(CGA.BRIGHT_WHITE, CGA.BLUE)
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