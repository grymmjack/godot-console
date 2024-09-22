# ANSI Text Parser for Godot 4
# @author Rick Christy <grymmjack@gmail.com>
# @requires Godot 4.3+

class_name AnsiParser
extends TextConsole

var sauce_data:SauceParser.SauceData = null
var ansi_width:int
var ansi_height:int

func parse_ansi(data:PackedByteArray) -> void:
	# Process data
	var data_length:int = data.size()
	var i:int = 0
	while i < data_length:
		var char_code:int = data[i]
		i += 1

		if char_code == 27:  # ESC character
			if i >= data_length:
				break  # End of data
			var next_char:int = data[i]
			i += 1
			if next_char == "[".unicode_at(0):
				# Start of CSI sequence
				var ansi_sequence:String = ""
				# Read characters until we find a letter between '@' (64) and '~' (126)
				while i < data_length:
					var c:int = data[i]
					i += 1
					ansi_sequence += String.chr(c)
					if c >= 64 and c <= 126:
						# Found the final character
						break
				# Now process the ansi_sequence
				process_ansi_sequence(ansi_sequence)
		else:
			if char_code == 10:  # LF (Line Feed)
				_set_cursor_position(Vector2i(0, cursor_position.y+1))
			elif char_code == 13:  # CR (Carriage Return)
				_set_cursor_position(Vector2i(0, cursor_position.y))
			else:
				# Draw character
				if !utf8_ans:
					echo(ASCII_UNICODE[char_code])
				else:
					echo(String.chr(ASCII_UNICODE.find(char_code)))

func process_ansi_sequence(seq:String) -> void:
	if seq == '':
		return
	var final_char:String = seq[seq.length() - 1]
	var params_str:String = seq.substr(0, seq.length() - 1)
	var params = []
	if params_str != '':
		params = params_str.split(';')
	else:
		params = ['0']  # Default parameter

	# Convert parameters to integers
	var params_int:Array[int] = []
	for p:String in params:
		if p == '':
			p = '0'
		var n:int = int(p)
		params_int.append(n)

	# Now handle the command based on final_char
	match final_char:
		'm': # SGR - Select Graphic Rendition
			process_sgr(params_int)
		'H', 'f': # Cursor position
			process_cursor_position(params_int)
		'A': # Cursor up
			cursor_up(params_int)
		'B': # Cursor down
			cursor_down(params_int)
		'C': # Cursor forward
			cursor_right(params_int)
		'D': # Cursor backward
			cursor_left(params_int)
		's': # TODO Save cursor position - not yet supported
			#save_cursor_position()
			pass
		'u': # TODO Restore cursor position - not yet supported
			#restore_cursor_position()
			pass
		# Add other commands as needed
		_:
			# Unhandled command
			pass

func process_sgr(params:Array[int]) -> void:
	if params.size() == 0:
		params = [0]
	for p:int in params:
		match p:
			0: # Reset all attributes
				foreground_color = CGA.WHITE  # Default foreground
				background_color = CGA.BLACK  # Default background
				bold = false
				blinking = false
				inverted = false
			1: # Bold on (bright foreground)
				bold = true
				if foreground_color < 8:
					foreground_color += 8
			2,22: # Enable low intensity, disable high intensity
				bold = false
				if foreground_color > 7:
					foreground_color -= 8
			5,6: # Blink on
				blinking = true
				if background_color < 8:
					background_color += 8
			7: # Reverse video on
				if !inverted:
					inverted = true
			25: # Blink off
				blinking = false
				if background_color > 7:
					background_color -= 8
			27: # Reverse video off
				if inverted:
					inverted = false
			30,31,32,33,34,35,36,37: # Set foreground color
				foreground_color = p - 30
				if bold:
					foreground_color += 8
			38: # TODO 256 color foreground - not yet supported
				foreground_color = params[2]
			39: # Set default foreground color
				foreground_color = CGA.WHITE
			40,41,42,43,44,45,46,47: # Set background color
				background_color = p - 40
				if blinking:
					background_color += 8
			48: # TODO 256 color background - not yet supported
				background_color = params[2]
			49: # Set default background color
				background_color = CGA.BLACK
			90,91,92,93,94,95,96,97: # Set high intensity foreground color
				foreground_color = p - 90 + 8
			100,101,102,103,104,105,106,107: # Set high intensity background color
				background_color = p - 90 + 8
			_:
				# Unhandled SGR code
				pass

# Cursor movement functions
func process_cursor_position(params) -> void:
	var row = 1
	var col = 1
	if params.size() >= 1 and params[0] != '':
		row = params[0]
	if params.size() >= 2 and params[1] != '':
		col = params[1]
	locate(col, row)

func cursor_home(params:Array) -> void:
	var row = int(params[0]) - 1 if (params.size() > 0) else 0
	var col = int(params[1]) - 1 if (params.size() > 1) else 0
	set_cursor_position(Vector2i(col, row))

func cursor_up(params:Array) -> void:
	var count = int(params[0]) if (params.size() > 0) else 1
	move_cursor(Vector2i(0, -count))

func cursor_down(params:Array) -> void:
	var count = int(params[0]) if (params.size() > 0) else 1
	move_cursor(Vector2i(0, count))

func cursor_right(params:Array) -> void:
	var count = int(params[0]) if (params.size() > 0) else 1
	move_cursor(Vector2i(count, 0))

func cursor_left(params:Array) -> void:
	var count = int(params[0]) if (params.size() > 0) else 1
	move_cursor(Vector2i(-count, 0))

@warning_ignore("unused_parameter")
func cursor_col0_down(params:Array) -> void:
	cursor_position.x = 0
	move_cursor(Vector2i(0, 1))

@warning_ignore("unused_parameter")
func cursor_col0_up(params:Array) -> void:
	cursor_position.x = 0
	move_cursor(Vector2i(0, -1))

func cursor_move_col(params:Array) -> void:
	if params.size() > 0:
		var col = int(params[0]) - 1  # Convert to 0-based index
		set_cursor_position(Vector2i(col, cursor_position.y))

func erase_screen(params:Array) -> void:
	if params.size() > 0 and params[0] == "2":
		cls()

func erase_line(params:Array) -> void:
	if params.size() > 0 and params[0] == "2":
		clear_line(cursor_position.y)

func clear_line(line_index:int) -> void:
	for x in range(columns):
		bg(Vector2i(x, line_index), background_color)
		fg(Vector2i(x, line_index), foreground_color, cha_to_atlas_coord(" "))

func reset_styles() -> void:
	reset_colors()

func reset_colors() -> void:
	foreground_color = CGA.WHITE
	background_color = CGA.BLACK

func move_cursor(delta: Vector2i) -> void:
	cursor_position += delta
	screen_wrap()

func set_cursor_position(_pos:Vector2i) -> void:
	cursor_position = _pos
	screen_wrap()

func get_cursor_position() -> Vector2i:
	return cursor_position

@warning_ignore("unused_parameter")
func set_bold(enabled: bool) -> void:
	pass

@warning_ignore("unused_parameter")
func set_dimmed(enabled: bool) -> void:
	pass

@warning_ignore("unused_parameter")
func set_italic(enabled: bool) -> void:
	pass

@warning_ignore("unused_parameter")
func set_underline(enabled: bool) -> void:
	pass

func swap_colors() -> void:
	var temp = foreground_color
	foreground_color = background_color
	background_color = temp

func load_ansi_file(file_path:String) -> void:
	utf8_ans = ".utf8ans" in file_path
	var sauce_parser = SauceParser.new()
	var content_length:int = 0
	sauce_data = sauce_parser.parse_sauce(file_path)

	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		if sauce_data:
			# Exclude SAUCE record and comments from content
			content_length = sauce_data.FileSize

			# Setup ANSI Flags https://www.acid.org/info/sauce/sauce.htm#ANSiFlags
			ice_color = sauce_data.Flags & sauce_parser.ANSI_FLAG_ICE_COLOR
			font_8px = (sauce_data.Flags & sauce_parser.ANSI_FLAG_FONT_8PX) and not (sauce_data.Flags & sauce_parser.ANSI_FLAG_FONT_9PX)
			font_9px = (sauce_data.Flags & sauce_parser.ANSI_FLAG_FONT_9PX) and not (sauce_data.Flags & sauce_parser.ANSI_FLAG_FONT_8PX)
			if (sauce_data.Flags & sauce_parser.ANSI_FLAG_LEGACY_ASPECT) and not (sauce_data.Flags & sauce_parser.ANSI_FLAG_SQUARE_ASPECT):
				aspect_ratio = ASPECT_RATIO.LEGACY
			if (sauce_data.Flags & sauce_parser.ANSI_FLAG_SQUARE_ASPECT) and not (sauce_data.Flags & sauce_parser.ANSI_FLAG_LEGACY_ASPECT):
				aspect_ratio = ASPECT_RATIO.SQUARE

			# Extract width
			ansi_width = sauce_data.TInfo1
			ansi_height = sauce_data.TInfo2
		else:
			content_length = file.get_length()

		var content:PackedByteArray
		for i:int in range(content_length):
			content.append(file.get_8())
		file.close()
		parse_ansi(content)
	else:
		print("Failed to open file: %s" % file_path)
