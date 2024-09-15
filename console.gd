extends RichTextLabel

func _ready() -> void:
	#for char in GLOBAL.DOS_ANSI_CHARACTERS_DECIMAL:
		#text += String.chr(GLOBAL.DOS_ANSI_CHARACTERS_DECIMAL[char])
		#print("%x" % GLOBAL.DOS_ANSI_CHARACTERS_DECIMAL[char])
	text = "[color=#%s]" % G.CGA_PALETTE[G.CGA.CYAN].to_html(false)
	load_text_from_file("res://test/text2.txt")
	text += "[/color]"


func load_text_from_file(path: String):
	var char
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.ModeFlags.READ)
		while file.get_position() < file.get_length():
			char = file.get_8()
			if char == 13:
				text += " "
			else:
				text += String.chr(char)
		file.close()
