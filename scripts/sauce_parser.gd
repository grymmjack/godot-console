class_name SauceParser
extends TextConsole

const SAUCE_ID := "SAUCE"
const SAUCE_VERSION := "00"

# SAUCE record structure sizes
const SAUCE_RECORD_SIZE := 128
const COMMENT_BLOCK_SIZE := 64
const COMMENT_ID := "COMNT"

# SAUCE data structure
class SauceData:
	var ID: String = ""
	var Version: String = ""
	var Title: String = ""
	var Author: String = ""
	var Group: String = ""
	var Date: String = ""
	var FileSize: int = 0
	var DataType: int = 0
	var FileType: int = 0
	var TInfo1: int = 0
	var TInfo2: int = 0
	var TInfo3: int = 0
	var TInfo4: int = 0
	var Comments: int = 0
	var Flags: int = 0
	var Filler: String = ""
	var CommentLines: Array = []

func parse_sauce(file_path: String) -> SauceData:
	var sauce_data = SauceData.new()
	var file = FileAccess.open(file_path, FileAccess.READ)

	if !file:
		print("Failed to open file: %s" % file_path)
		return null

	var file_size = file.get_length()
	if file_size < SAUCE_RECORD_SIZE:
		# File is too small to contain SAUCE record
		file.close()
		return null

	# Seek to potential SAUCE record position
	file.seek(file_size - SAUCE_RECORD_SIZE)
	var data = file.get_buffer(SAUCE_RECORD_SIZE)
	var data_str = data.get_string_from_ascii()

	if not data_str.begins_with(SAUCE_ID):
		# No SAUCE record found
		file.close()
		return null

	# Parse SAUCE record
	sauce_data.ID = data.get_string_from_ascii().substr(0, 5)
	sauce_data.Version = data.get_string_from_ascii().substr(5, 2)
	sauce_data.Title = data.get_string_from_ascii().substr(7, 35).strip_edges()
	sauce_data.Author = data.get_string_from_ascii().substr(42, 20).strip_edges()
	sauce_data.Group = data.get_string_from_ascii().substr(62, 20).strip_edges()
	sauce_data.Date = data.get_string_from_ascii().substr(82, 8).strip_edges()
	sauce_data.FileSize = bytes_to_int(data.slice(90, 94))  # 4 bytes for FileSize
	sauce_data.DataType = data[94]
	sauce_data.FileType = data[95]
	sauce_data.TInfo1 = bytes_to_int(data.slice(96, 98))  # 2 bytes for TInfo1
	sauce_data.TInfo2 = bytes_to_int(data.slice(98, 100))  # 2 bytes for TInfo2
	sauce_data.TInfo3 = bytes_to_int(data.slice(100, 102))  # 2 bytes for TInfo3
	sauce_data.TInfo4 = bytes_to_int(data.slice(102, 104))  # 2 bytes for TInfo4
	sauce_data.Comments = data[104]
	sauce_data.Flags = data[105]
	sauce_data.Filler = data.get_string_from_ascii().substr(106, 22)

	# Parse comments if any
	if sauce_data.Comments > 0:
		var comment_block_position = file_size - SAUCE_RECORD_SIZE - (COMMENT_BLOCK_SIZE * sauce_data.Comments)
		file.seek(comment_block_position)
		var comment_id_data = file.get_buffer(5)
		var comment_id_str = comment_id_data.get_string_from_ascii()
		if comment_id_str == COMMENT_ID:
			for i in range(sauce_data.Comments):
				var comment_line_data = file.get_buffer(COMMENT_BLOCK_SIZE)
				var comment_line = comment_line_data.get_string_from_ascii().strip_edges()
				sauce_data.CommentLines.append(comment_line)
		else:
			print("Invalid comment block identifier.")

	file.close()
	return sauce_data

func bytes_to_int(bytes: PackedByteArray) -> int:
	var result = 0
	for i in range(bytes.size()):
		result = (result << 8) + bytes[i]
	return result