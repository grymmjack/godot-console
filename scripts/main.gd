@icon("res://icon.svg")
class_name TextScreen
extends AnsiParser

func _ready() -> void:
	#create_colored_tiles(CGA_PALETTE, BASE_TILESET_8x8, "DOS 8x8", "CGA")
	#create_colored_tiles(CGA_PALETTE, BASE_TILESET_8x16, "DOS 8x16", "CGA")
	#create_colored_tiles(CGA_PALETTE, BASE_TILESET_9x16, "DOS 9x16", "CGA")
	#get_tree().quit(0)
	#color(CGA.BRIGHT_WHITE, CGA.BLUE)
	#cls()
	#print_ruler()
	#locate(79, 0)
	#cecho("Hello, World!", 14, 4)
	#load_ansi_file("res://assets/stormtrooper-pixel-art.png-25-OPT.ans")
	load_ansi_file("res://assets/ANSIs/gj-fuel2.ans")
	#load_ansi_file("res://assets/gj-fuel2-8x14.ans")
	#locate(0, 50)
	#echo("Hi")
	#echo("A")
	#if sauce_data != null:
		## Display metadata at the top of the console
		#locate(0, 0)
		#color(CGA.BRIGHT_WHITE, CGA.BLACK)
		#echo("Title: %s" % sauce_data.Title)
		#locate(0, 1)
		#echo("Author: %s" % sauce_data.Author)
		#locate(0, 2)
		#echo("Group: %s" % sauce_data.Group)
		#locate(0, 3)
		#echo("Date: %s" % sauce_data.Date)

func _input(event):
	if event is InputEventKey:
		print(OS.get_keycode_string(event.keycode))
		if OS.get_keycode_string(event.keycode) == "Escape":
			get_tree().quit()

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
