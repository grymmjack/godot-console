extends RichTextLabel

func _ready() -> void:
	add_theme_constant_override("text_highlight_v_padding", 0)
	add_theme_constant_override("text_highlight_h_padding", 0)
	add_theme_constant_override("line_separation", 0)
	# example bgcolor and color (fg) working!
	text = "[color=#%s]" % G.CGA_PALETTE[G.CGA.CYAN].to_html(false)
	text += "[bgcolor=#%s]" % G.CGA_PALETTE[G.CGA.BLUE].to_html(false)
	load_text_from_file("res://test/text2.txt")
	text += "[/bgcolor][/color]"
	text += "       "
	text += "[color=#%s]" % G.CGA_PALETTE[G.CGA.CYAN].to_html(false)
	text += "[bgcolor=#%s]" % G.CGA_PALETTE[G.CGA.BLUE].to_html(false)
	text += String.chr(G.DOS_ANSI_CHARACTERS_DECIMAL["F1"])
	text += "[bgcolor=#%s]" % G.CGA_PALETTE[G.CGA.CYAN].to_html(false)
	text += "[color=#%s]" % G.CGA_PALETTE[G.CGA.BLUE].to_html(false)
	text += String.chr(G.DOS_ANSI_CHARACTERS_DECIMAL["F3"])

func load_text_from_file(path: String):
	var character
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.ModeFlags.READ)
		while file.get_position() < file.get_length():
			character = file.get_8()
			if character == 13:
				text += " "
			else:
				text += String.chr(character)
		file.close()
