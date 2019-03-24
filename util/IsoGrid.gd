extends Node

class_name IsoGrid

var cell_size := Vector2(128,64)
var center_offset := Vector2(0,cell_size.y/2)

var dungeon setget set_dungeon
var tile_map

func set_dungeon(dungeon_in) -> void:
	if !dungeon_in:
		dungeon = null
		return
	dungeon = dungeon_in
	var  d_tile_map = dungeon_in.find_node("TileMap")
	if !d_tile_map:
		tile_map = null
		return
	tile_map = d_tile_map
	cell_size = tile_map.cell_size
	center_offset = Vector2(0,cell_size.y/2)

func world_to_map(world_position : Vector2) -> Vector2:
#	if !tile_map:
#		return Vector2()
	return tile_map.world_to_map(world_position)
	
func map_to_world(map_position : Vector2, include_offset := true) -> Vector2:
#	if !tile_map:
#		return Vector2()
	return tile_map.map_to_world(map_position) + (center_offset if include_offset else Vector2())
	
func get_point_path(start_pos : Vector2, end_pos : Vector2) -> PoolVector3Array:
	"""
	Assumes the positions are already converted to map coordinates
	"""
	if !dungeon:
		return PoolVector3Array()
	return dungeon.get_point_path(start_pos,end_pos)
	
func get_move_path(start : Vector2, end : Vector2) -> PoolVector2Array:
	"""
	@param start is the position to path from, in world coordinates
	@param end is the position to path to, in world coordinates
	"""
	var start_pos = world_to_map(start)
	var cursor_pos = world_to_map(end)
#	print(str(start_pos,":",cursor_pos))
	var vec3_path = get_point_path(start_pos,cursor_pos)
	var move_path = array_vec3_to_vec2(vec3_path)
#	(world.get_node("Line2D") as Line2D).points = move_path
	return move_path
		
func array_vec3_to_vec2( move_path : PoolVector3Array) -> PoolVector2Array:
	var points2 = PoolVector2Array()
	for each in move_path:
		points2.append(map_to_world(Vector2(each.x,each.y), true))
#	print(points2)
	return points2

func set_tile(pos : Vector2, tile_index : int) -> void:
	"""
	Assumes the positions are already converted to map coordinated
	"""
	if(!tile_map):
		return
	tile_map.set_cell(pos.x,pos.y,tile_index)

func get_tile(pos : Vector2) -> int:
	if(!tile_map):
		return TileMap.INVALID_CELL
	return tile_map.get_cell(pos.x,pos.y)

func highlight_area(pos : Vector2, tile_index : int, dist := 1, use_diagonals := false, flying := false) -> void:
	"""
	Assumes the positions are already converted to map coordinated
	"""
	if(get_tile(pos) != TileMap.INVALID_CELL):
		set_tile(pos,tile_index)
#		return
	elif !flying:
		return
	#call this method on 
	if(dist > 0):
		highlight_area(pos + dir.NORTH, tile_index, dist-1, use_diagonals, flying)
		highlight_area(pos + dir.EAST, tile_index, dist-1, use_diagonals, flying)
		highlight_area(pos + dir.SOUTH, tile_index, dist-1, use_diagonals, flying)
		highlight_area(pos + dir.WEST, tile_index, dist-1, use_diagonals, flying)
		if(use_diagonals):
			highlight_area(pos + dir.NORTH_EAST, tile_index, dist-1.5, use_diagonals, flying)
			highlight_area(pos + dir.SOUTH_EAST, tile_index, dist-1.5, use_diagonals, flying)
			highlight_area(pos + dir.SOUTH_WEST, tile_index, dist-1.5, use_diagonals, flying)
			highlight_area(pos + dir.NORTH_WEST, tile_index, dist-1.5, use_diagonals, flying)