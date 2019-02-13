"""
This script will cut the terrain tile png into regions
and save them as a resource. each tile will have it's own id based on its location.
Run once to get the terrain_tile.tres (resource file)
"""

extends Node

var tile_size = Vector2(128, 128)  # this is a constant

# $ (= get_node) the sprite node, save the texture property to a variable 
# (that is the png assigned to texture)
# onready makes the var available even before the _ready() func is called
onready var texture = $Sprite.texture  

func _ready():
	var tex_width = texture.get_width() / tile_size.x  # number of horizontal tiles
	var tex_height = texture.get_height() / tile_size.y  # number of vertical tiles
	var ts = TileSet.new()  # new tileset object
	for x in range(tex_width):
		for y in range(tex_height):
			var region = Rect2(x * tile_size.x, y * tile_size.y,
								tile_size.x, tile_size.y)  # x, y, width, height
			var id = x + y * 10  # assign unique id for each tile
			ts.create_tile(id)  # create tile with id
			ts.tile_set_texture(id, texture)  # assign texture to tile (whole texture)
			ts.tile_set_region(id, region)  # specify tile region whitin texture
		ResourceSaver.save("res://terrain/terrain_tiles.tres", ts)  # save resource

