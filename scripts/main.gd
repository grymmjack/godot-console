@icon("res://icon.svg")
class_name TextScreen
extends AnsiParser

func _ready() -> void:
	#create_colored_tiles(CGA_PALETTE, BASE_TILESET_8x8, "DOS 8x8", "CGA")
	#create_colored_tiles(CGA_PALETTE, BASE_TILESET_8x16, "DOS 8x16", "CGA")
	#create_colored_tiles(CGA_PALETTE, BASE_TILESET_9x16, "DOS 9x16", "CGA")
	#get_tree().quit(0)
	color(CGA.BRIGHT_WHITE, CGA.BLACK)
	cls()
	##print_ruler()
	#var msg:String = "Hello, World!"
	#locate_center(msg, int(rows/2))
	#cecho(msg, 14, 4)
	#await inkey()
	#await Input
	#load_ansi_file("res://assets/ANSIs/Giant Rat.gif-50.ans") # 33x25 - 8x8 font
	#load_ansi_file("res://assets/ANSIs/filth - Blackalicious - Blazing Arrow - MoebiusXBIN GJ.ans")
	#load_ansi_file("res://assets/ANSIs/bobafett.png-25-noice.ans") # 320x100
	#load_ansi_file("res://assets/ANSIs/bobafett.png-25-noice.ans") # 320x100
	#load_ansi_file("res://assets/ANSIs/bacsi-img2pal.png-25-OPT.ans") # 320x100
	#load_ansi_file("res://assets/ANSIs/akbar.png-25-moebius.ans")
	#load_ansi_file("res://assets/ANSIs/gj-test1.ans")
	#load_ansi_file("res://assets/ANSIs/gj-test2.ans")
	#load_ansi_file("res://assets/ANSIs/MB4K.ans")
	#load_ansi_file("res://assets/ANSIs/anst-moebius.ans")
	#load_ansi_file("res://assets/ANSIs/acknowledgements.ans")
	#load_ansi_file("res://assets/ANSIs/gj-jorge-test.ans")
	#load_ansi_file("res://assets/ANSIs/stormtrooper-pixel-art.png-25.ans")
	#load_ansi_file("res://assets/ANSIs/stormtrooper-pixel-art.png-25-OPT.ans")
	load_ansi_file("res://assets/ANSIs/gj-fuel2.ans")
	#load_ansi_file("res://assets/ANSIs/gj-fuel2-8x14.ans")
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
		#print(OS.get_keycode_string(event.keycode))
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
