extends "res://actors/Entity.gd"

class_name EntityLiving

onready var portrait := $Portrait
onready var health := $Living/Health
onready var traits := $Living/Traits
onready var morale := $Living/Morale
onready var inventory := $Living/Inventory
onready var body := get_node("Living/Body").get_child(0)

enum REST_TYPE {
	BREATH, #10 minutes, recover stamina
	SHORT, #1 hour, spent eating/cleaning wounds/etc
	LONG, #8 hours, a night's rest
	BED, #24 hours, spent in bed
	EXTENDED #one week, used to learn new skills & level up
}

export (int) var max_move_tiles = 5
var show_move_range := false

var initiative : int

var _destination : Vector2 setget set_destination, get_destination
#var _intermediate_destination : Vector2 setget _set_intermediate_destination, _get_intermediate_destination
#var _last_destination : Vector2
var _movement_path : PoolVector2Array 
var _move_to_destination := false

func _ready():
	$EntityArea.connect("mouse_exited", self, "_on_EntityArea_mouse_exited")
	$EntityArea.connect("entity_clicked", self, "_on_EntityArea_entity_clicked")
	pass

func roll_initiative() -> int:
	initiative = dice.roll20(traits.get_trait_val("dex") - traits.get_trait_val("bul"))
	return initiative

func _process(delta) -> void:
	#check if reached intermediate destination
#	if position.distance_to(_intermediate_destination) == 0:
#		if _movement_path.size() > 0:
#			_intermediate_destination = _movement_path[0]
#			_movement_path.remove(0)
#		_move_to_destination = false
	if _movement_path.size() > 1:
		_move_to_destination = true
	do_movement(max(max_move_tiles,3))

func do_movement(distance : float) -> void:
	var start_point := position
	for i in range (_movement_path.size()):
		var move_dest = (_movement_path[0])
		var distance_to_next = position.distance_to(move_dest)
		if distance <= distance_to_next and distance >= 0.0:
			_move_to_destination = true
			position = start_point.linear_interpolate(move_dest, distance / distance_to_next)
			break
		elif _movement_path.size() == 1 and distance > distance_to_next:
			_move_to_destination = false
			position = move_dest
			_movement_path.remove(0)
			break
		distance -= distance_to_next
		start_point = move_dest
		_movement_path.remove(0)
		emit_signal("on_enter_cell", iso.world_to_map(position))

func get_max_move_tiles() -> int:
	return max_move_tiles

func set_destination(destination_in : Vector2) -> bool:
	"""
	@param destination_in the Vector2 in WORLD coordinates that is set to be the current destination.

	@returns false if the destination is not valid or the entity is already at the destination

	"""
	if iso.world_to_map(_destination) == iso.world_to_map(destination_in): # is already at the destination
		return false
	var path_found = iso.get_move_path(position, destination_in)
	if path_found.size() < 1:
		return false
	_destination = destination_in
	_movement_path = path_found
#	print(str("size of movement_path is ",_movement_path.size()))
#	_set_intermediate_destination(_movement_path[0])
	_move_to_destination = true
	return true

func get_destination() -> Vector2:
	return _destination

func _on_EntityArea_entity_clicked(button_index):
	if not button_index == BUTTON_LEFT:
		return
	if not show_move_range:
		iso.highlight_area(iso.world_to_map(global_position), 1, max_move_tiles, false)
		show_move_range = true
#	else:
#		iso.highlight_area(iso.world_to_map(global_position), 1, max_move_tiles, false)

func _on_EntityArea_mouse_exited():
#	if():
	if show_move_range:
		iso.highlight_area(iso.world_to_map(global_position), 0, max_move_tiles, false)
		show_move_range = false

#func _set_intermediate_destination(destination_in : Vector2) -> void:
#	"""
#	in map coordinates
#	@param destinaiton_in is the value that _intermediate_destination is set to
#	@var _intermediate_destination is the coordinate that the entity will @method linear_interpolate to
#	"""
#	_intermediate_destination = destination_in

#func _get_intermediate_destination() -> Vector2:
#	return _intermediate_destination