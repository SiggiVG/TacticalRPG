extends "res://actors/Entity.gd"

"""
Represents an entity which has a semblence of autonomy
They can move while having a destination and could have AI associated with them
They can take basic actions such as Stride, Step, Strike
"""
class_name EntityLiving

onready var portrait := $Portrait
onready var health := $Living/Health
onready var traits := $Living/Traits
onready var morale := $Living/Morale
onready var inventory := $Living/Inventory
onready var body := get_node("Living/Body").get_child(0)

signal on_entity_enter_tile(entity, world_position, action_used)

var acceleration := 0
var slowness := 0

enum REST_TYPE {
	BREATH, #10 minutes, recover stamina
	SHORT, #1 hour, spent eating/cleaning wounds/etc
	LONG, #8 hours, a night's rest
	BED, #24 hours, spent in bed
	EXTENDED #one week, used to learn new skills & level up
}

export var max_move_tiles := 5
export var reach := 1

var actions_remaining := 3
var reactions_remaining := 1

var initiative : int

#var _destination : Vector2 setget set_destination, get_destination
#var _intermediate_destination : Vector2 setget _set_intermediate_destination, _get_intermediate_destination
#var _last_destination : Vector2
var _movement_path : PoolVector2Array 
var _move_to_destination := false

func _ready():
	._ready()
#	$EntityArea.connect("mouse_exited", self, "_on_EntityArea_mouse_exited")
	$EntityArea.connect("entity_clicked", self, "_on_EntityArea_entity_clicked")
	pass

func _begin_turn() -> void:
	actions_remaining = 3
	reactions_remaining = 1

func roll_initiative() -> int:
	initiative = dice.roll20(traits.get_trait_val("dex") - traits.get_trait_val("bul"))
	return initiative

func get_move_speed() -> int:
	"""
	@returns the amount of tiles that the entity is currently able to move in a single stride action
	"""
	return int(max(0,max_move_tiles + acceleration - slowness))

func take_damage(type := "generic", amount := 1) -> int:
	var dam =  health.take_damage(amount)
	if(health.current_health <= 0):
		print (str(name, " has been slain!"))
	return dam

func _process(delta) -> void:
	pass
#	._process(delta)
	#check if reached intermediate destination
#	if position.distance_to(_intermediate_destination) == 0:
#		if _movement_path.size() > 0:
#			_intermediate_destination = _movement_path[0]
#			_movement_path.remove(0)
#		_move_to_destination = false
#	if _movement_path.size() > 1:
#		_move_to_destination = true
#	else:
#		print(get_node("Living/DrawLine").points)
#	do_movement(max(max_move_tiles,3))

#func do_movement(distance : float) -> void:
#	var start_point := position
#	var draw_line = get_node("Living/DrawLine")
#	for i in range (_movement_path.size()):
#		var move_dest = (_movement_path[0])
#		var distance_to_next = position.distance_to(move_dest)
#		#ensures the distance is within bounds so it doesnt pass
#		if distance <= distance_to_next and distance >= 0.0:
#			_move_to_destination = true
#			position = start_point.linear_interpolate(move_dest, distance / distance_to_next)
#			var temp_line = _movement_path
#			temp_line.insert(0,position)
#			draw_line.points = temp_line
#			break
#		#ensures you dont pass the last node
#		elif _movement_path.size() == 1 and distance > distance_to_next: 
#			_move_to_destination = false
#			position = move_dest
#			_movement_path.remove(0)
#			draw_line.points = _movement_path
#			break
#		distance -= distance_to_next
#		start_point = move_dest
#		_movement_path.remove(0)
#		var temp_line = _movement_path
#		temp_line.insert(0,position)
#		draw_line.points = temp_line
##		draw_line.show()
#		emit_signal("on_enter_cell", iso.world_to_map(position))

func get_max_move_tiles() -> int:
	return max_move_tiles

func _can_stride() -> bool:
	return max_move_tiles > 0

#func set_destination(destination_in : Vector2) -> bool:
##	print("destination set")
#	"""
#	@param destination_in the Vector2 in WORLD coordinates that is set to be the current destination.
#
#	@returns false if the destination is not valid or the entity is already at the destination
#
#	"""
#	if iso.world_to_map(_destination) == iso.world_to_map(destination_in): # is already at the destination
#		return false
#	var path_found = iso.get_move_path(position, destination_in)
#	if path_found.size() < 1:
#		return false
#	"""
#	clunky implementation of keeping the move_path within the movable area
#	TODO: make a better implementation, such as manipulating polygons into a clickable area?
#	"""
#	var collision_shape = (get_node("EntityArea/CollisionShape2D") as CollisionShape2D)
#	var shape := generate_move_select_polygon()
	
#	for i in range(max_move_tiles+1, path_found.size()):
##		print(str(i,":",path_found.size()))
##		path_found.remove(path_found.size()-1)
#	_destination = path_found[path_found.size()-1]
#	_movement_path = path_found
#	get_node("Living/DrawLine").points = _movement_path
##	print(str("size of movement_path is ",_movement_path.size()))
##	_set_intermediate_destination(_movement_path[0])
#	_move_to_destination = true
#	return true

#func get_destination() -> Vector2:
#	return _destination

#func _on_entity_enter_tile(world_pos : Vector2):
#	emit_signal("on_entity_enter_tile", self, world_pos, cur_action)
#	pass

#func generate_move_select_polygon(num_of_squares := max_move_tiles) -> Polygon2D:
#	var poly := Polygon2D.new()
#
#
#
#	return poly

func _on_entity_selected() -> bool:
#	print(str(name," has been selected"))
	return true
	
#	if not show_move_range and not _move_to_destination:
#		iso.highlight_area(iso.world_to_map(global_position), 1, max_move_tiles, false)
#		show_move_range = true
#		print(show_move_range)
#	else:
#		iso.highlight_area(iso.world_to_map(global_position), 1, max_move_tiles, false)


#func _on_EntityArea_mouse_exited():
#	if():
#	if show_move_range:
#		iso.highlight_area(iso.world_to_map(global_position), 0, max_move_tiles, false)
#		show_move_range = false

#func _set_intermediate_destination(destination_in : Vector2) -> void:
#	"""
#	in map coordinates
#	@param destinaiton_in is the value that _intermediate_destination is set to
#	@var _intermediate_destination is the coordinate that the entity will @method linear_interpolate to
#	"""
#	_intermediate_destination = destination_in

#func _get_intermediate_destination() -> Vector2:
#	return _intermediate_destination