extends Node2D

class_name Dungeon

#onready var line_2d := $Line2D
onready var tile_map := $TileMap

export var grid_neg_x := 0
export var grid_neg_y := -16
export var grid_x := 32
export var grid_y := 16
export var nav_cardinal := true
export var nav_intercardinal := false

var astar := AStar.new()

onready var offset_to_center = Vector2(0, tile_map.cell_size.y / 2)

func _ready():
#	for i in range(grid_neg_x,grid_x):
#		for j in range(grid_neg_y,grid_y):
#			var cell = rand_range(-1,5)
#			if(cell > 0):
#				tile_map.set_cell(i,j,0)
	build_paths()
	pass

func add_item_to_world(item, pos : Vector2) -> void:
	if(item == null):
		print(str("No item to add to the Dungeon called ",name))
		return
	item.position = pos
	item.get_node("Sprite").show()
	get_node("Items").add_child(item)
	
	print("Item called ",item.name," was added to the Dungeon called ",name)

func vec_to_id(vec : Vector2) -> int:
	return int(((abs(grid_neg_y) + vec.y) * grid_x) + abs(grid_neg_x) + vec.x)

func build_paths() -> void:
	#fill astar with navigable points
	for i in range(grid_neg_x,grid_x):
		for j in range (grid_neg_y,grid_y):
			var vec = Vector2(i,j)
			if(is_tile_traversable(vec)): 
				astar.add_point(vec_to_id(vec),Vector3(vec.x, vec.y,0))
#	print(astar.get_points())
	#connect points
	for i in range(grid_neg_x,grid_x):
		for j in range (grid_neg_y,grid_y):
			var vec = Vector2(i,j)
			
			if(nav_cardinal):
				if(is_tile_traversable(vec+dir.NORTH)):
					astar.connect_points(vec_to_id(vec), vec_to_id(vec+dir.NORTH),false)
				if(is_tile_traversable(vec+dir.EAST)):
					astar.connect_points(vec_to_id(vec), vec_to_id(vec+dir.EAST),false)
				if(is_tile_traversable(vec+dir.SOUTH)):
					astar.connect_points(vec_to_id(vec), vec_to_id(vec+dir.SOUTH),false)
				if(is_tile_traversable(vec+dir.WEST)):
					astar.connect_points(vec_to_id(vec), vec_to_id(vec+dir.WEST),false)
			if(nav_intercardinal):
				if(is_tile_traversable(vec+dir.NORTH_EAST)):
					astar.connect_points(vec_to_id(vec), vec_to_id(vec+dir.NORTH_EAST),false)
				if(is_tile_traversable(vec+dir.SOUTH_EAST)):
					astar.connect_points(vec_to_id(vec), vec_to_id(vec+dir.SOUTH_EAST),false)
				if(is_tile_traversable(vec+dir.SOUTH_WEST)):
					astar.connect_points(vec_to_id(vec), vec_to_id(vec+dir.SOUTH_WEST),false)
				if(is_tile_traversable(vec+dir.NORTH_WEST)):
					astar.connect_points(vec_to_id(vec), vec_to_id(vec+dir.NORTH_WEST),false)

func get_point_path(start : Vector2, end : Vector2) -> PoolVector3Array:
#	print(astar.get_points())
#	print(str(vec_to_id(start),":", vec_to_id(end)))
	var move_path = astar.get_point_path(vec_to_id(start), vec_to_id(end))
#	print(move_path)
	return move_path

func world_to_map(pos : Vector2) -> Vector2:
	return tile_map.world_to_map(pos)

func map_to_world(pos : Vector2) -> Vector2:
	return tile_map.map_to_world(pos)

func is_tile_traversable(point : Vector2) -> bool:
	#test for out of bounds
	if(point.x < grid_neg_x or point.x >= grid_x) or (point.y < grid_neg_y or point.y >= grid_y):
		return false
	return tile_map.get_cell(point.x,point.y) != TileMap.INVALID_CELL