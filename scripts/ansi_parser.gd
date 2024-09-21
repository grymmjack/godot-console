class_name AnsiParser
extends TextConsole

const ESC := 27
const CSI := "%c[" % ESC

# CURSOR
const CURSOR_HOME         := "H"
const CURSOR_MOVE1        := "H"
const CURSOR_MOVE2        := "f"
const CURSOR_UP           := "A"
const CURSOR_DOWN         := "B"
const CURSOR_RIGHT        := "C"
const CURSOR_LEFT         := "D"
const CURSOR_COL0_DOWN    := "E"
const CURSOR_COL0_UP      := "F"
const CURSOR_MOVE_COL     := "G"
const CURSOR_SCROLL_UP    := "M"
const CURSOR_SAVE_POS     := "s"
const CURSOR_REST_POS     := "u"

# ERASE
const ERASE_CURSOR_EOS    := "0J"
const ERASE_CURSOR_BOS    := "1J"
const ERASE_SCREEN        := "2J"
const ERASE_CRSR_EOL      := "0K"
const ERASE_CRSR_BOL      := "1K"
const ERASE_LINE          := "2K"

# GRAPHICS MODES
const GFX_RESET           := "0m"
const GFX_BOLD            := "1m"
const GFX_DIMMED          := "2m"
const GFX_ITALIC          := "3m"
const GFX_UNDERLINE       := "4m"
const GFX_BLINKING        := "5m"
const GFX_INVERSE         := "7m"
const GFX_HIDDEN          := "8m"
const GFX_STRIKEOUT       := "9m"

# FOREGROUND COLORS
const COLOR_RESET         := "0m"
const COLOR_FG_DEFAULT    := "39m"
const COLOR_FG_BLACK      := "0;30"
const COLOR_FG_BLUE       := "0;34"
const COLOR_FG_GREEN      := "0;32"
const COLOR_FG_CYAN       := "0;36"
const COLOR_FG_RED        := "0;31"
const COLOR_FG_MAGENTA    := "0;35"
const COLOR_FG_BROWN      := "0;33"
const COLOR_FG_WHITE      := "0;37"
const COLOR_FG_GRAY       := "1;30"
const COLOR_FG_BR_BLUE    := "1;34"
const COLOR_FG_BR_GREEN   := "1;32"
const COLOR_FG_BR_CYAN    := "1;36"
const COLOR_FG_BR_RED     := "1;31"
const COLOR_FG_BR_MAGENTA := "1;35"
const COLOR_FG_BR_BROWN   := "1;33"
const COLOR_FG_BR_WHITE   := "1;37"

# BACKGROUND COLORS
const COLOR_BG_BLACK      := "40"
const COLOR_BG_BLUE       := "44"
const COLOR_BG_GREEN      := "42"
const COLOR_BG_CYAN       := "46"
const COLOR_BG_RED        := "41"
const COLOR_BG_MAGENTA    := "45"
const COLOR_BG_BROWN      := "43"
const COLOR_BG_WHITE      := "47"
const COLOR_BG_GRAY       := "5;40"
const COLOR_BG_BR_BLUE    := "5;44"
const COLOR_BG_BR_GREEN   := "5;42"
const COLOR_BG_BR_CYAN    := "5;46"
const COLOR_BG_BR_RED     := "5;41"
const COLOR_BG_BR_MAGENTA := "5;45"
const COLOR_BG_BR_BROWN   := "5;43"
const COLOR_BG_BR_WHITE   := "5;47"

# Initialize default colors
var current_fg_color:int = CGA.WHITE
var current_bg_color:int = CGA.BLACK

func packedbyearray_to_string_utf8(_input:PackedByteArray) -> String:
	var ret:String = ""
	for i:int in range(_input.size()):
		if _input[i] != 27:
			ret += ASCII_UNICODE[_input[i]]
		else:
			ret += String.chr(27)
	return ret

func utf8_to_string8(_input:String) -> String:
	var ret:String = ""
	for i:int in range(len(_input)):
		if _input[i] != String.chr(27):
			ret += String.chr(UNICODE_ASCII[_input[i]])
		else:
			ret += String.chr(27)
	return ret

func parse_ansi(data: PackedByteArray):
	# Process data
	var data_length = data.size()
	var i = 0
	while i < data_length:
		var char_code = data[i]
		i += 1

		if char_code == 27:  # ESC character
			if i >= data_length:
				break  # End of data
			var next_char = data[i]
			i += 1
			if next_char == '['.unicode_at(0):
				# Start of CSI sequence
				var ansi_sequence = ''
				# Read characters until we find a letter between '@' (64) and '~' (126)
				while i < data_length:
					var c = data[i]
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
				echo(ASCII_UNICODE[char_code])
				#echo(String.chr(char_code))

func process_ansi_sequence(seq):
	#if '43m' in seq:
		#breakpoint
	if seq == '':
		return
	var final_char = seq[seq.length() - 1]
	var params_str = seq.substr(0, seq.length() - 1)
	var params = []
	if params_str != '':
		params = params_str.split(';')
	else:
		params = ['0']  # Default parameter
	# Convert parameters to integers
	var params_int = []
	for p in params:
		if p == '':
			p = '0'
		var n = int(p)
		params_int.append(n)
	# Now handle the command based on final_char
	match final_char:
		'm':
			# SGR - Select Graphic Rendition
			process_sgr(params_int)
		'H', 'f':
			# Cursor position
			process_cursor_position(params_int)
		'A':
			# Cursor up
			cursor_up(params_int)
		'B':
			# Cursor down
			cursor_down(params_int)
		'C':
			# Cursor forward
			cursor_right(params_int)
		'D':
			# Cursor backward
			cursor_left(params_int)
		#'s':
			# Save cursor position
			#save_cursor_position()
		#'u':
			# Restore cursor position
			#restore_cursor_position()
		# Add other commands as needed
		_:
			# Unhandled command
			pass

func process_sgr(params):
	if params.size() == 0:
		params = [0]
	for p in params:
		match p:
			0:
				# Reset all attributes
				foreground_color = CGA.WHITE  # Default foreground
				background_color = CGA.BLACK  # Default background
				bright = false
				blink = false
			1:
				# Bold on (bright foreground)
				foreground_color += 8
				bright = true
			#22:
				 #Bold off
				#if foreground_color >= 8:
					#foreground_color -= 8
			5:
				 #Blink on
				blink = true
				bright = true
			25:
				 #Blink off
				blink = false
			p when (p >= 30 and p <= 37):
				# Set foreground color
				foreground_color = p - 30 if !bright else p - 30 + 8
			p when (p >= 40 and p <= 47):
				# Set background color
				background_color = p - 40# if !bright else p - 40 + 8
			p when (p >= 90 and p <= 97):
				# Set bright foreground color
				foreground_color = p - 90 if !bright else p - 90 + 8
			p when (p >= 100 and p <= 107):
				# Set bright background color
				background_color = p - 100 if !bright else p - 100 + 8
			# Add other attributes if needed
			_:
				# Unhandled SGR code
				pass

# Cursor movement functions
func process_cursor_position(params):
	var row = 1
	var col = 1
	if params.size() >= 1 and params[0] != '':
		row = params[0]
	if params.size() >= 2 and params[1] != '':
		col = params[1]
	# ANSI positions are 1-based, but our x and y are 0-based
	locate(col, row)

func cursor_home(params: Array):
	var row = int(params[0]) - 1 if (params.size() > 0) else 0
	var col = int(params[1]) - 1 if (params.size() > 1) else 0
	set_cursor_position(Vector2i(col, row))

func cursor_up(params: Array):
	var count = int(params[0]) if (params.size() > 0) else 1
	move_cursor(Vector2i(0, -count))

func cursor_down(params: Array):
	var count = int(params[0]) if (params.size() > 0) else 1
	move_cursor(Vector2i(0, count))

func cursor_right(params: Array):
	var count = int(params[0]) if (params.size() > 0) else 1
	move_cursor(Vector2i(count, 0))

func cursor_left(params: Array):
	var count = int(params[0]) if (params.size() > 0) else 1
	move_cursor(Vector2i(-count, 0))

@warning_ignore("unused_parameter")
func cursor_col0_down(params: Array):
	cursor_position.x = 0
	move_cursor(Vector2i(0, 1))

@warning_ignore("unused_parameter")
func cursor_col0_up(params: Array):
	cursor_position.x = 0
	move_cursor(Vector2i(0, -1))

func cursor_move_col(params: Array):
	if params.size() > 0:
		var col = int(params[0]) - 1  # Convert to 0-based index
		set_cursor_position(Vector2i(col, cursor_position.y))

func erase_screen(params: Array):
	if params.size() > 0 and params[0] == "2":
		cls()
	# Handle other erase options if needed

func erase_line(params: Array):
	if params.size() > 0 and params[0] == "2":
		clear_line(cursor_position.y)
	# Handle other erase options if needed

func clear_line(line_index: int):
	for x in range(columns):
		bg(Vector2i(x, line_index), current_bg_color)
		fg(Vector2i(x, line_index), current_fg_color, cha_to_atlas_coord(" "))

func reset_styles():
	reset_colors()
	# Reset other styles as needed

func reset_colors():
	current_fg_color = CGA.WHITE
	current_bg_color = CGA.BLACK
	update_console_color()

func update_console_color():
	color(current_fg_color, current_bg_color)

func move_cursor(delta: Vector2i):
	cursor_position += delta
	screen_wrap()

func set_cursor_position(_pos: Vector2i):
	cursor_position = _pos
	screen_wrap()

func get_cursor_position() -> Vector2i:
	return cursor_position

@warning_ignore("unused_parameter")
func set_bold(enabled: bool):
	# Implement bold text style if applicable
	pass

@warning_ignore("unused_parameter")
func set_dimmed(enabled: bool):
	# Implement dimmed text style if applicable
	pass

@warning_ignore("unused_parameter")
func set_italic(enabled: bool):
	# Implement italic text style if applicable
	pass

@warning_ignore("unused_parameter")
func set_underline(enabled: bool):
	# Implement underline text style if applicable
	pass

func swap_colors():
	var temp = current_fg_color
	current_fg_color = current_bg_color
	current_bg_color = temp
	update_console_color()

var sauce_data: SauceParser.SauceData = null
func load_ansi_file(file_path: String) -> void:
	var sauce_parser = SauceParser.new()
	sauce_data = sauce_parser.parse_sauce(file_path)

	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var content_length = file.get_length()
		if sauce_data != null:
			# Exclude SAUCE record and comments from content
			content_length -= sauce_parser.SAUCE_RECORD_SIZE + (sauce_parser.COMMENT_BLOCK_SIZE * sauce_data.Comments) + 1
		var content:PackedByteArray
		for i:int in range(content_length):
			content.append(file.get_8())
		#var content = file.get_as_text()
		file.close()
		#breakpoint
		parse_ansi(content)
	else:
		print("Failed to open file: %s" % file_path)
