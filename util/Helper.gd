extends Node

class_name Helper

func array_vec3_to_vec2( move_path : PoolVector3Array, convert_to_world := false, dungeon_map = null, offset := Vector2()) -> PoolVector2Array:
	var points2 = PoolVector2Array()
#	print(move_path)
	if !dungeon_map:
		 return points2
	for each in move_path:
		if convert_to_world:
			points2.append(dungeon_map.map_to_world(Vector2(each.x,each.y)) + offset)
		else:
			points2.append(Vector2(each.x,each.y) + offset)
#	print(points2)
	return points2