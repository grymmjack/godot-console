extends RichTextLabel

func _ready() -> void:
	load_text_from_file("res://test/test.txt")


func load_text_from_file(path: String):
	var file = FileAccess.open(path, FileAccess.ModeFlags.READ)
	if file:
		var content = file.get_as_text()
		text = content
		file.close()
	else:
		printerr("Failed to open file: ", path)
