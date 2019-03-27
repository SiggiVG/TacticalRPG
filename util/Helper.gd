extends Node

class_name Helper

func array_vec3_to_vec2( move_path : PoolVector3Array, convert_to_world := false, dungeon_map = null) -> PoolVector2Array:
	var points2 = PoolVector2Array()
	print(move_path)
	for each in move_path:
		if convert_to_world and dungeon_map:
			points2.append(dungeon_map.map_to_world(Vector2(each.x,each.y)))
		else:
			points2.append(Vector2(each.x,each.y))
#	print(points2)
	return points2