extends Node2D

class_name DungeonZoom

var cell_size : Vector2 setget set_cell_size

#terrain
onready var floor_map := $LevelMap/FloorMap
onready var wall_map := $LevelMap/WallMap
onready var decor_map := $LevelMap/DecorMap
onready var ceiling_map := $LevelMap/CeilingMap

#position highlighting
#should probably make the wall map transparent when they would cover a highlight
onready var highlight_map := $HighlightMap
onready var fog_map := $FogOfWarMap

func _set_up_maps(cell_size_in : Vector2) -> void:
	"""
	Sets all the tilemaps to use the correct mode and cell size
	TODO: have it create the node if it does not exist
	
	Note: stairs/holes/etc will lead to another dungeon map level
	"""
	
	floor_map.mode = TileMap.MODE_ISOMETRIC
	wall_map.mode = TileMap.MODE_ISOMETRIC
	decor_map.mode = TileMap.MODE_ISOMETRIC
	ceiling_map.mode = TileMap.MODE_ISOMETRIC
	highlight_map.mode = TileMap.MODE_ISOMETRIC
	ceiling_map.mode = TileMap.MODE_ISOMETRIC
	set_cell_size(cell_size_in)

func set_cell_size(cell_size_in : Vector2) -> void:
	floor_map.cell_size = cell_size_in
	wall_map.cell_size = cell_size_in
	decor_map.cell_size = cell_size_in
	ceiling_map.cell_size = cell_size_in
	highlight_map.cell_size = cell_size_in
	fog_map.cell_size = cell_size_in
	
func set_tile_set(floor_set = null, wall = null, decor = null, ceiling = null, highlight = null, fog = null  ) -> void:
	"""
	Used for quickly swapping tile sets between sets with the same index mappings
	Primarily for different zoom values
	"""
	if floor_set:
		floor_map.tile_set = floor_set
	if wall:
		wall_map.tile_set = wall
	if decor:
		decor_map.tile_set = decor
	if ceiling:
		ceiling_map.tile_set = ceiling
	if highlight:
		highlight_map.tile_set = highlight
#		print ("meh")
	if fog:
		fog_map.tile_set = fog

func clear(map_type) -> void:
	match map_type:
		DungeonMap.MAP_TYPE.FLOOR:
			floor_map.clear()
		DungeonMap.MAP_TYPE.WALL:
			wall_map.clear()
		DungeonMap.MAP_TYPE.DECOR:
			decor_map.clear()
		DungeonMap.MAP_TYPE.CEILING:
			ceiling_map.clear()
		DungeonMap.MAP_TYPE.HIGHLIGHT:
			highlight_map.clear()
		DungeonMap.MAP_TYPE.FOG:
			fog_map.clear()

func set_tile(map_type, pos : Vector2, tile_index : int) -> void:
	"""
	sets a tile in the chosen map to the chosen tile id
	TODO: have it work with strings too, so tiles can be placed by unlocalized name
		will require a map of string to values?
	"""
#	if pos_is_in_world_coords:
#		pos = world_to_map(pos)
#	var dungeon_map = get_parent()
#	if dungeon_map.within_bounds(pos):
#		print("ass")
#		return
	match map_type:
		DungeonMap.MAP_TYPE.FLOOR:
#			print(str(pos.x,":",pos.y))
			floor_map.set_cellv(pos, tile_index)
		DungeonMap.MAP_TYPE.WALL:
			wall_map.set_cellv(pos, tile_index)
		DungeonMap.MAP_TYPE.DECOR:
			decor_map.set_cellv(pos, tile_index)
		DungeonMap.MAP_TYPE.CEILING:
			ceiling_map.set_cellv(pos, tile_index)
		DungeonMap.MAP_TYPE.HIGHLIGHT:
			highlight_map.set_cellv(pos, tile_index)
		DungeonMap.MAP_TYPE.FOG:
			fog_map.set_cellv(pos, tile_index)
			
func get_tile(map_type, pos : Vector2, as_string := false) -> int:
	"""
	@return the tile id at the chosen destination
	TODO: have it be able to return a string that is the name of the tile
	
	possibly write another method that builds a map of all the id : tiles
	"""
#	if pos_is_in_world_coords:
#		pos = world_to_map(pos)
#	var dungeon_map = get_parent()
	match map_type:
		DungeonMap.MAP_TYPE.FLOOR:
			return floor_map.get_cellv(pos)
		DungeonMap.MAP_TYPE.WALL:
			return wall_map.get_cellv(pos)
		DungeonMap.MAP_TYPE.DECOR:
			return decor_map.get_cellv(pos)
		DungeonMap.MAP_TYPE.CEILING:
			return ceiling_map.get_cellv(pos)
		DungeonMap.MAP_TYPE.HIGHLIGHT:
			return highlight_map.get_cellv(pos)
		DungeonMap.MAP_TYPE.FOG:
			return fog_map.get_cellv(pos)
		_:	
			return TileMap.INVALID_CELL
			
func world_to_map(point : Vector2) -> Vector2:
	return floor_map.world_to_map(point)
	
func map_to_world(point : Vector2) -> Vector2:
	return floor_map.map_to_world(point)