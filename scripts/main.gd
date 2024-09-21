@icon("res://icon.svg")
class_name TextScreen
extends AnsiParser

func _ready() -> void:
	#create_colored_tiles(CGA_PALETTE, BASE_TILESET, "DOS 8x16", "CGA")
	#color(CGA.BRIGHT_WHITE, CGA.BLUE)
	#print_ruler()
	#locate(79, 0)
	#cecho("Hello, World!", 14, 4)
	#echo("Hello, World!")
	#echo("Hello, World!")
	#echo("Hello, World!")
	#echo("Hello, World!")
	#echo("Hello, World!")
	#echo("Hello, World!")
	#echo("Hello, World!")
	#echo("Hello, World!")
	#echo("Hello, World!")
	#echo("Hello, World!")
	#echo("Hello, World!")
	#echo("Hello, World!")
	#echo("Hello, World!")
	#echo("Hello, World!")
	load_ansi_file("res://assets/gj-test1.ans")
	locate(0, 20)
	echo("Hi")
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
