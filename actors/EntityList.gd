extends Node

class_name EntityList

onready var d_map := get_node("../DungeonMap") as DungeonMap

func _ready():
	var ents = get_entities()
	for each in ents:
		each.position = d_map.map_to_world(d_map.world_to_map(each.position))

func get_entities() -> Array:
	var ents = []
	for each in get_children():
		if each is EntityLiving:
			ents.append(each)
	return ents

func is_entity_at(pos : Vector2, is_in_world_coords := false):
	return get_entity_at(pos, is_in_world_coords) != null

func get_entity_at(pos : Vector2, is_in_world_coords := false):
	if is_in_world_coords:
		pos = d_map.world_to_map(pos)
	var ents = get_entities()
	print (ents)
	for each in ents:
		if d_map.world_to_map(each.position) == pos:
			return each
	return null