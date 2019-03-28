extends Action

class_name ActionStride

var last_pos
var destination
var move_path
var provokes_aoo_on_exit := true
var maximum_movement := -1

signal tile_entered(entity, tile_pos, action)
signal tile_exited(entity, tile_pos, action)

func _ready() -> void:
	_add_trait("move")
	set_process(false)
	
func _on_initiated() -> bool:
	if not entity is EntityLiving:
		return false
	if !entity._can_stride():
		return false
	var movement = entity.get_move_speed()
	if(maximum_movement != -1):
		movement = min(maximum_movement, movement)
	if(movement > 0):
		#adds 1.0 as it starts out expanded by 1
		"""
		TODO move fix to the iso method
		"""
		d_map.highlight_area(entity.global_position, 1, true, movement+1.0)
		return true
	return false

func _check_valid() -> bool:
	var move_path_calc = d_map.get_move_path(entity.global_position, destination, true)
	var cost = d_map.compute_path_cost(move_path_calc)
	var movement = entity.get_move_speed()
	if(maximum_movement != -1):
		movement = min(maximum_movement, entity.get_move_speed())
	#adds 0.5 to move speed to allow for a single diagonal movement to only count as 1 move.
	if cost == -1 or cost > movement+.5 or move_path_calc.size() <= 1:
		_reset()
		return false
	move_path = move_path_calc
	last_pos = entity.position
	return true

func _do_action() -> bool:
	var dist = max(entity.get_move_speed(),3)
#	if !move_path:
##		action_status = Action.STATUS.FINISHED
#		return false
	# if leaving a tile
	#the tile_exited signal will be passed to other entities to determine if they can take an Attack of Opportunity
	#with the way this will be setup, if they have a feat to stop movement or succeed in grapple etc, it will interrupt the action
	if entity.position == last_pos:
		emit_signal("tile_exited", entity, d_map.world_to_map(entity.position), self)
		move_path.remove(0)
	var dist_to_next = entity.position.distance_to(move_path[0])
	# if it can move towards the destination by dist without ovverunning it
	if dist <= dist_to_next:
		entity.position = entity.position.linear_interpolate(move_path[0], dist / dist_to_next)
		return false
	# if it is the last node in the move path it will avoid overunning it
	elif move_path.size() == 1 and dist > dist_to_next:
		return true
	emit_signal("tile_entered", entity, d_map.world_to_map(entity.position), self)
	entity.position = move_path[0]
	last_pos = entity.position
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
	move_path = null
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