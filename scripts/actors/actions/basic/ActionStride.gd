extends Action

class_name ActionStride

onready var line := get_parent().get_node("Line2D")

var last_pos
var path_pos
var destination
var append_move_path := false
var partial_move_path := PoolVector2Array()
var move_path := PoolVector2Array()
var provokes_aoo_on_exit := true
var maximum_movement := -1
var movement_remaining := maximum_movement

signal tile_entered(entity, tile_pos, action)
signal tile_exited(entity, tile_pos, action)

func _ready() -> void:
	_add_trait("move")
	set_process(false)
	
func _on_initiated() -> bool:
	append_move_path = false
	partial_move_path = PoolVector2Array()
	move_path = PoolVector2Array()
	if not entity is Entity:
		return false
	last_pos = entity.global_position
	path_pos = last_pos
	if !entity._can_stride():
		return false
	movement_remaining = entity.get_move_speed()
	if(maximum_movement != -1):
		movement_remaining = min(maximum_movement, movement_remaining)
	if(movement_remaining > 0):
		#adds 1.0 as it starts out expanded by 1
		"""
		TODO move fix to the iso method
		"""
		d_map.highlight_area(last_pos, 1, true, movement_remaining+1.0)
		return true
	return false

func _check_valid() -> bool:
	var move_path_calc = d_map.get_move_path(path_pos, destination, true)
	var cost = d_map.compute_path_cost(move_path_calc)
#	var movement = entity.get_move_speed()
	if(maximum_movement != -1):
		movement_remaining = min(maximum_movement, movement_remaining)
	#adds 0.5 to move speed to allow for a single diagonal movement to only count as 1 move.
	if cost == -1 or cost > movement_remaining+.5 or move_path_calc.size() <= 1:
		_reset()
		return false
	move_path.append_array(move_path_calc)
	path_pos = move_path[move_path.size()-1]
	movement_remaining -= cost
	line.points = move_path
	return true

func _do_action() -> bool:
	var dist = max(entity.get_move_speed(),3)
#	if !move_path:
##		action_status = Action.STATUS.FINISHED
#		return false
	# if leaving a tile
	#the tile_exited signal will be passed to other entities to determine if they can take an Attack of Opportunity
	#with the way this will be setup, if they have a feat to stop movement or succeed in grapple etc, it will interrupt the action
	if entity.global_position == last_pos:
		emit_signal("tile_exited", entity, d_map.world_to_map(entity.global_position), self)
		move_path.remove(0)
		line.points = move_path
	var dist_to_next = entity.global_position.distance_to(move_path[0])
	# if it can move towards the destination by dist without ovverunning it
	if dist <= dist_to_next:
		entity.global_position = entity.global_position.linear_interpolate(move_path[0], dist / dist_to_next)
		line.points[0] = entity.global_position
		return false
	# if it is the last node in the move path it will avoid overunning it
	elif move_path.size() == 1 and dist > dist_to_next:
		return true
	emit_signal("tile_entered", entity, d_map.world_to_map(entity.position), self)
	entity.global_position = move_path[0]
	last_pos = entity.global_position
	
	return false

func _on_interrupted() -> bool:
	return true

func _on_finished() -> bool:
	return true

func _on_canceled() -> bool:
	return true

func _reset() -> void:
	get_parent().get_parent().cur_action = null
	last_pos = null
	destination = null
	path_pos = null
	partial_move_path = PoolVector2Array()
	move_path = PoolVector2Array()
	action_status = null
	set_process(false)

func _input(event):
	if(action_status == Action.STATUS.INPUT):
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT and event.is_pressed():
				destination = get_viewport().get_mouse_position()
				#hide selection area
				d_map.clear_highlight()
				action_status = Action.STATUS.CHECK_VALID
			elif event.button_index == BUTTON_RIGHT and event.is_pressed():
				destination = get_viewport().get_mouse_position()
				d_map.clear_highlight()
				_check_valid()
				if movement_remaining > 0:
					print(movement_remaining)
					d_map.highlight_area(path_pos, 1, true, movement_remaining+1.0)
				else:
					action_status = Action.STATUS.DO_ACTION