extends Node2D

class_name DungeonMap

enum MAP_TYPE {
	FLOOR, WALL, DECOR, CEILING,
	HIGHLIGHT,
	FOG
}

#onready var zoomed_map = $ZoomIn
onready var tile_map = $Map

onready var zoomed_tile_set = preload("res://TileSetIsoFog.tres")
onready var full_tile_set = preload("res://TileSetIso.tres")

#var map_bounds : Vector2 = Vector2(32,32)
var astar := AStar.new()

enum ZOOM { IN, OUT }
var zoom = ZOOM.OUT

func zoom_in() -> void:
	set_zoom(ZOOM.IN)

func zoom_out() -> void:
	set_zoom(ZOOM.OUT)
		
func set_zoom(zoom_val):
	"""
	returns the value zoom is set to
	"""
	match zoom_val:
		ZOOM.IN:
			if zoom == ZOOM.OUT:
				tile_map.cell_size = consts.ZOOM_CELL_SIZE
				tile_map.set_tile_set(zoomed_tile_set)
				zoom = ZOOM.IN
		ZOOM.OUT:
			if zoom == ZOOM.IN:
				tile_map.cell_size = consts.FULL_CELL_SIZE
				tile_map.set_tile_set(full_tile_set)
				zoom = ZOOM.OUT
	return zoom
		
		

func _ready() -> void:
#	zoomed_map._set_up_maps(consts.ZOOM_CELL_SIZE)
	zoom = ZOOM.OUT
#	zoomed_map.hide()
	tile_map._set_up_maps(consts.ZOOM_CELL_SIZE if zoom == ZOOM.IN else consts.FULL_CELL_SIZE)
#	tile_map.show()
	_on_map_loaded()

func load_map():#map_max_bounds : Vector2) -> void:
	"""
	Currenly only sets the map bounds (-x/2 <= X < x/2, -y/2 <= Y < y/2)
		as there is not yet any map loading functionality
	"""
#	map_bounds = map_max_bounds
	
#	set_tile(MAP_TYPE.FLOOR, Vector2(0,0), 0, false)
#	set_tile(MAP_TYPE.FLOOR, Vector2(15,15), 0, false)
#	print (tile_map.get_children())
	for i in range (0,43):
		for j in range (0,43):
#			print(i,":",j)
			if within_bounds(Vector2(i,j)):
				set_tile(MAP_TYPE.FLOOR, Vector2(i,j), 5, false)
	

func _on_map_loaded() -> bool:
	"""
	@returns true if successfully loaded
	
	currently no state that it could be false,
		but in the future it will return false upon a file not being of the proper format or being corrupted
	"""
	load_map()
	_build_paths(tile_map.floor_map, tile_map.wall_map)
	
	return true
	
func _build_paths(floors : TileMap, obstacles : TileMap) -> void:
#	print (str( floors,":",obstacles))
	astar.clear()
	"""
	called when a tilemap has been loaded in, filling A8's graph with navigable points and connecting them
	if the map is changed somehow, this should be called to update the A* graph
	"""
	#fill astar with navigable points
	for vec in floors.get_used_cells():
#		print(vec)
		if(is_tile_traversable(vec)): 
			astar.add_point(_vec_to_index(vec),Vector3(vec.x, vec.y,0))
				
	#connect points
	for vec in floors.get_used_cells():
		if(consts.PATH_CARDINAL):
#			print (vec+dir.NORTH)
			if(is_tile_traversable(vec+dir.NORTH)):
				astar.connect_points(_vec_to_index(vec), _vec_to_index(vec+dir.NORTH))
#				print("north")
			if(is_tile_traversable(vec+dir.EAST)):
				astar.connect_points(_vec_to_index(vec), _vec_to_index(vec+dir.EAST))
#				print("east")
			if(is_tile_traversable(vec+dir.SOUTH)):
				astar.connect_points(_vec_to_index(vec), _vec_to_index(vec+dir.SOUTH))
#				print("south")
			if(is_tile_traversable(vec+dir.WEST)):
				astar.connect_points(_vec_to_index(vec), _vec_to_index(vec+dir.WEST))
#				print("west")
		if(consts.PATH_INTERCARDINAL):
			if(is_tile_traversable(vec+dir.NORTH_EAST)):
				astar.connect_points(_vec_to_index(vec), _vec_to_index(vec+dir.NORTH_EAST))
			if(is_tile_traversable(vec+dir.SOUTH_EAST)):
				astar.connect_points(_vec_to_index(vec), _vec_to_index(vec+dir.SOUTH_EAST))
			if(is_tile_traversable(vec+dir.SOUTH_WEST)):
				astar.connect_points(_vec_to_index(vec), _vec_to_index(vec+dir.SOUTH_WEST))
			if(is_tile_traversable(vec+dir.NORTH_WEST)):
				astar.connect_points(_vec_to_index(vec), _vec_to_index(vec+dir.NORTH_WEST))
#	print(astar.get_points().size())

func is_tile_traversable(point : Vector2, point_is_in_world_coords := false) -> bool:
	"""
	@returns true if there is something to stand on in the floor tile (is not empty space)
			and if there is nothing at that location in the wall tile (is empty space)
	"""
	if point_is_in_world_coords:
		point = world_to_map(point)
	#test for out of bounds
#	if not within_bounds(point):
##		print("hope")
#		return false
	return get_tile(MAP_TYPE.FLOOR, point) != TileMap.INVALID_CELL and get_tile(MAP_TYPE.WALL, point) == TileMap.INVALID_CELL

func world_to_map(point : Vector2) -> Vector2:
#	match zoom_level:
#		ZOOM.IN:
#			return zoomed_map.world_to_map(point)
#		ZOOM.OUT:
	return tile_map.world_to_map(point - position)
#		_: return Vector2()
	
func map_to_world(point : Vector2) -> Vector2:
#	match zoom_level:
#		ZOOM.IN:
#			return zoomed_map.map_to_world(point)
#		ZOOM.OUT:
	return tile_map.map_to_world(point) + position
#		_: return Vector2()

func get_move_path(start : Vector2, end : Vector2, pos_is_in_world_coords := false) -> PoolVector2Array:
	"""
	@param start is the position to path from
	@param end is the position to path to
	"""
	
	if pos_is_in_world_coords:
		start = world_to_map(start)
		end = world_to_map(end)
		
	var vec3_path = _get_point_path(start,end, false)
	var move_path = helper.array_vec3_to_vec2(vec3_path, true, self)
	
	return move_path

func _get_point_path(start : Vector2, end : Vector2, pos_is_in_world_coords := false) -> PoolVector3Array:
	"""
	FOR PRIVATE USE ONLY
	use get_move_path() which calls this function!
	
	used to get the path of points from one position to another, in map coords
	returns a PoolVector3Array which should be converted for use with 2D
	"""
	if pos_is_in_world_coords:
		start = world_to_map(start)
		end = world_to_map(end)
#	print(astar.get_points())
#	print(str(vec_to_id(start),":", vec_to_id(end)))
	var move_path = astar.get_point_path(_vec_to_index(start), _vec_to_index(end))
#	print(move_path)
	return move_path

func compute_path_cost(path : PoolVector2Array) -> float:
	if path.size() < 1: return -1.0
	var last = world_to_map(path[0])
	var res = 0.0
	for i in range(1,path.size()):
#		print((world_to_map(path[i])-last))
		if dir.is_cardinal(world_to_map(path[i])-last):
			res += consts.CARDINAL_COST
		elif dir.is_intercardinal(world_to_map(path[i])-last):
			res += consts.INTERCARDINAL_COST
		last = world_to_map(path[i])
#	print(str("cost ",res))
	return res

#func _to_world_vec2_array(points : PoolVector2Array) -> PoolVector2Array:
#	for i in points.size()-1:
#		points[i] = map_to_world(points[i])
#	return points

func _vec_to_index(vec : Vector2) -> int:
	"""
	Converts a vector (in map coordinates) into the index used by the A* pathfinder
	"""
	return int((vec.y * 50) + vec.x)
	
func set_tile(map_type, point : Vector2, tile_index : int, pos_is_in_world_coords := false) -> void:
	"""
	sets a tile in the chosen map to the chosen tile id
	TODO: have it work with strings too, so tiles can be placed by unlocalized name
		will require a map of string to values?
	TODO: IMPORTANT: ensure that both maps have their values set
	"""
#	var pos2 := point
	if pos_is_in_world_coords:
#		pos2 = world_to_map(ZOOM.OUT, point)
		point = world_to_map(point)
		
	if not within_bounds(point):
#		print (pos2)
#		print ("poop")
		return
#	print(str(point.x,":",point.y))
#	if point.x < consts.top_left.x or point.x > consts.bot_right.x or point.y < consts.top_right.y or point.y > consts.bot_left.y:
#		print ("toot")
#		return
#	if zoom == ZOOM.IN:
#	zoomed_map.set_tile(map_type, point, tile_index)
#	elif zoom == ZOOM.OUT:
	tile_map.set_tile(map_type, point, tile_index)
#	print (str(pos," : ", pos2))
			
func get_tile(map_type, pos : Vector2, pos_is_in_world_coords := false) -> int:
	if pos_is_in_world_coords:
		pos = world_to_map(pos)
#	if zoom == ZOOM.IN:
#		return zoomed_map.get_tile(map_type, pos)
#	elif zoom == ZOOM.OUT:
	return tile_map.get_tile(map_type, pos)
#	return TileMap.INVALID_CELL
	
func within_bounds(pos : Vector2) -> bool:
	if pos.x < 0 or pos.y < 0:
		return false
		
	"""
	temprary condition
	"""
	#for zoomed in
	#x + y >= 9
	#y-10 <= x
	#x-10 <= y
	#x + y <= 32
	#for zoomed out
	if pos.x + pos.y >= 9 and pos.x + pos.y <= 64:
		if pos.x >= (pos.y - 20) and (pos.x-20) <= pos.y:
#			print(pos)
			return true
#	print(pos)
	return false
	
func clear_highlight() -> void:
	tile_map.clear(MAP_TYPE.HIGHLIGHT)

func highlight_area(pos : Vector2, tile_index : int, is_in_world_coords := false, dist := 1.0, flying := false) -> void:
	"""
	Assumes the positions are already converted to map coordinates
	"""
	if is_in_world_coords:
		pos = world_to_map(pos)
	if is_tile_traversable(pos):
#		print("fart")
		set_tile(MAP_TYPE.HIGHLIGHT, pos,tile_index)
	elif !flying:
		return
	#distances
	if(consts.PATH_CARDINAL and dist > consts.CARDINAL_COST):
		highlight_area(pos + dir.NORTH, tile_index, false, dist-consts.CARDINAL_COST, flying)
		highlight_area(pos + dir.EAST, tile_index, false, dist-consts.CARDINAL_COST, flying)
		highlight_area(pos + dir.SOUTH, tile_index, false, dist-consts.CARDINAL_COST, flying)
		highlight_area(pos + dir.WEST, tile_index, false, dist-consts.CARDINAL_COST, flying)
		if(consts.PATH_INTERCARDINAL and dist > consts.INTERCARDINAL_COST):
			highlight_area(pos + dir.NORTH_EAST, tile_index, false, dist-consts.INTERCARDINAL_COST, flying)
			highlight_area(pos + dir.SOUTH_EAST, tile_index, false, dist-consts.INTERCARDINAL_COST, flying)
			highlight_area(pos + dir.SOUTH_WEST, tile_index, false, dist-consts.INTERCARDINAL_COST, flying)
			highlight_area(pos + dir.NORTH_WEST, tile_index, false, dist-consts.INTERCARDINAL_COST, flying)