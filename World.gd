extends Node2D

onready var line_2d := $Line2D
onready var tile_map := $Navigation2D/TileMap

export var grid_neg_x := 0
export var grid_neg_y := -16
export var grid_x := 32
export var grid_y := 16
export var nav_cardinal := true
export var nav_intercardinal := false


onready var offset_to_center = Vector2(0, tile_map.cell_size.y / 2)

var astar := AStar.new()

func _ready():
#	for i in range(grid_x):
#		for j in range(grid_y):
#			tile_map.set_cell(i,j,randi() % 2)
#		print(grid[i])
	build_paths()
	pass

func _unhandled_input(event):
	if event is InputEventMouseButton:
		draw_line_to_destination()
	pass

func draw_line_to_destination():
	var player = get_parent().find_node("Player")
	var start_pos = tile_map.world_to_map(player.position)
	var cursor_pos = tile_map.world_to_map(get_viewport().get_mouse_position())
#	print(str(start_pos,":",cursor_pos))
	var points = astar.get_point_path(vec_to_id(start_pos), vec_to_id(cursor_pos))
	print (points)	
	var points2 = PoolVector2Array()
	for each in points:
		points2.append(tile_map.map_to_world(Vector2(each.x,each.y))+offset_to_center)
#	print(points2)
	#TODO: point optimization?
	line_2d.points = points2
#	line_2d.points = [tile_map.map_to_world(start_pos)+offset_to_center,tile_map.map_to_world(cursor_pos)+offset_to_center]
	pass

func vec_to_id(vec : Vector2) -> int:
	return int(((abs(grid_neg_y) + vec.y) * grid_x) + abs(grid_neg_x) + vec.x)

func build_paths() -> void:
	#fill astar with navigable points
	for i in range(grid_neg_x,grid_x):
		for j in range (grid_neg_y,grid_y):
			var vec = Vector2(i,j)
			if(is_tile_traversable(vec)): 
#				print(vec)
				astar.add_point(vec_to_id(vec),Vector3(vec.x, vec.y,0))
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

func is_tile_traversable(point : Vector2) -> bool:
	#test for out of bounds
	if(point.x < grid_neg_x or point.x >= grid_x) or (point.y < grid_neg_y or point.y >= grid_y):
		return false
	return tile_map.get_cell(point.x,point.y) != TileMap.INVALID_CELL