# thank you to Selina - https://github.com/SelinaDev/
@tool
extends EditorScript

const BASE_FONT_TEXTURE:Texture2D = preload("res://assets/Perfect DOS VGA 437_2.png")
const BASE_TILESET:TileSet = preload("res://assets/DOSFont-SINGLE.tres")
const BASE_TILE_SIZE:Vector2i = Vector2i(8, 16)
const TARGET_PATH:String = "res://assets"
const COLORS = [
	Color(0, 0, 0),			# BLACK
	Color(0, 0, 170),		# BLUE
	Color(0, 170, 0),		# GREEN
	Color(0, 170, 170),		# CYAN
	Color(170, 0, 0),		# RED
	Color(170, 0, 170),		# MAGENTA
	Color(170, 85, 0),		# BROWN
	Color(170, 170, 170),	# WHITE
	Color(85, 85, 85),		# GRAY
	Color(85, 85, 255),		# BRIGHT BLUE
	Color(85, 255, 85),		# BRIGHT GREEN
	Color(85, 255, 255),	# BRIGHT CYAN
	Color(255, 85, 85),		# BRIGHT RED
	Color(255, 85, 255),	# BRIGHT MAGENTA
	Color(255, 255, 85),	# BRIGHT BROWN
	Color(255, 255, 255)	# BRIGHT WHITE
]

func _run() -> void:
	var tileset:TileSet = BASE_TILESET.duplicate(true)
	tileset.tile_size = BASE_TILE_SIZE
	var tileset_source:TileSetAtlasSource = tileset.get_source(0)
	tileset_source.separation = Vector2i(1, 1)
	tileset_source.texture_region_size = Vector2i(8, 16)
	tileset_source.texture = BASE_FONT_TEXTURE
	var color_num:int
	var _name:String
	var total_tiles:int = tileset_source.get_tiles_count()
	for i in range(total_tiles):
		var id:Vector2i = tileset_source.get_tile_id(i)
		for j:int in COLORS.size():
			color_num = j
			var _color: Color = COLORS[j]
			tileset_source.create_alternative_tile(id, j*i)
			#var tile_data: TileData = tileset_source.get_tile_data(id, j)
			#tile_data.modulate = _color
			_name = "Color-%d" % color_num
			tileset_source.resource_name = _name
			print(_name)
			ResourceSaver.save(tileset, TARGET_PATH + "/DOSFont-%s.tres" % _name)
