extends Node

"""
DECPRECIATED
TODO: move highlight functions to a script on the Highlight TileMap
"""

class_name IsoGrid

var cell_size := Vector2(128,64)
var center_offset := Vector2(0,cell_size.y/2)

var dungeon #setget set_dungeon
var tile_map #: Array
var highlight_map
var fog_map

func initialize() -> void:
	tile_map = get_node("LevelMap")#.get_children()
	highlight_map = get_node("HighlightMap")
	fog_map = get_node("FogOfWar")

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
	tile_map.cell_size = cell_size
	center_offset = Vector2(0,cell_size.y/2)
	var  d_highlight_map = dungeon_in.find_node("HighlightMap")
	if d_highlight_map:
		highlight_map = d_highlight_map
		highlight_map.cell_size = cell_size
	var d_fog_map = dungeon_in.find_node("FogOfWar")
	if d_fog_map:
		fog_map = d_fog_map
		fog_map.cell_size = cell_size
#
#
#func world_to_map(world_position : Vector2) -> Vector2:
##	if !tile_map:
##		return Vector2()
#	return tile_map.world_to_map(world_position)
#
#func map_to_world(map_position : Vector2, include_offset := true) -> Vector2:
##	if !tile_map:
##		return Vector2()
#	return tile_map.map_to_world(map_position) + (center_offset if include_offset else Vector2())
#
#func _get_point_path(start_pos : Vector2, end_pos : Vector2) -> PoolVector3Array:
#	"""
#	Assumes the positions are already converted to map coordinates
#	"""
#	if !dungeon:
#		return PoolVector3Array()
#	return dungeon.get_point_path(start_pos,end_pos)
#
#func get_move_path(start : Vector2, end : Vector2) -> PoolVector2Array:
#	"""
#	@param start is the position to path from, in world coordinates
#	@param end is the position to path to, in world coordinates
#	"""
#	var start_pos = world_to_map(start)
#	var cursor_pos = world_to_map(end)
##	print(str(start_pos,":",cursor_pos))
#	var vec3_path = _get_point_path(start_pos,cursor_pos)
#	var move_path = array_vec3_to_vec2(vec3_path)
##	(world.get_node("Line2D") as Line2D).points = move_path
#	return move_path
#
#func compute_path_cost(path : PoolVector2Array) -> float:
#	if path.size() < 1: return -1.0
#	var last = world_to_map(path[0])
#	var res = 0.0
#	for i in range(1,path.size()):
##		print((world_to_map(path[i])-last))
#		if dir.is_cardinal(world_to_map(path[i])-last):
#			res += 1.0
#		elif dir.is_intercardinal(world_to_map(path[i])-last):
#			res += 1.5
#		last = world_to_map(path[i])
##	print(str("cost ",res))
#	return res
#
#func array_vec3_to_vec2( move_path : PoolVector3Array) -> PoolVector2Array:
#	var points2 = PoolVector2Array()
#	for each in move_path:
#		points2.append(map_to_world(Vector2(each.x,each.y), true))
##	print(points2)
#	return points2
#
func set_tile(pos : Vector2, tile_index : int, map_index := 0) -> void:
	"""
	Assumes the positions are already converted to map coordinated
	"""
	var map = dungeon.get_child(map_index)
#	print(map)
	if map:
		map.set_cell(pos.x,pos.y,tile_index)

func get_tile(pos : Vector2, map_index := 0) -> int:
	var map = dungeon.get_child(map_index)
#	print(map)
	if(!map):
		return TileMap.INVALID_CELL
#	print(tile_map.name)
	return map.get_cell(pos.x,pos.y)

