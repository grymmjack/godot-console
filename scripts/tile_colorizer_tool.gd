# thank you to Selina - https://github.com/SelinaDev/
class_name TextTileColorizer
extends TextConsole

const BASE_FONT_TEXTURE:Texture2D = preload("res://assets/Perfect DOS VGA 437_2.png")
const BASE_TILESET:TileSet = preload("res://assets/DOSFont-SINGLE.tres")
const BASE_TILE_SIZE:Vector2i = Vector2i(8, 16)
const TARGET_PATH:String = "res://assets"

func _ready() -> void:
	create_colored_tiles(CGA_PALETTE)

func create_colored_tiles(colors) -> void:
	var tileset:TileSet = BASE_TILESET.duplicate(true)
	var tileset_source:TileSetAtlasSource = tileset.get_source(0)
	var grid_size:Vector2i = tileset_source.get_atlas_grid_size()
	var total_colors:int = colors.size()
	for c:int in range(0, total_colors):
		tileset_source.separation = Vector2i(1, 1)
		tileset_source.texture_region_size = Vector2i(8, 16)
		tileset_source.texture = BASE_FONT_TEXTURE
		var _color:Color = colors[c]
		print(colors[c])
		for y:int in range(grid_size.y):
			for x:int in range(grid_size.x):
				var id:int = tileset_source.create_alternative_tile(Vector2i(x, y), c + total_colors)
				var colored_tile_data:TileData = tileset_source.get_tile_data(Vector2i(x, y), id)
				colored_tile_data.modulate.r8 = colors[c].r
				colored_tile_data.modulate.g8 = colors[c].g
				colored_tile_data.modulate.b8 = colors[c].b
				var cha:String = String.chr(y * 31 + x)
		print("Created alternative tileset for COLOR %d" % [ c ])
	var filename:String =  TARGET_PATH + "/DOSFont-Alternates.tres"
	ResourceSaver.save(tileset, filename)
	print("Created %s" % filename)
