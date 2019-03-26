extends Action

class_name ActionStride

enum STRIDE_STATUS {
	BEGIN,
	INPUT,
	CHECK_VALID
	MOVE,
	INTERRUPTED,
	FINISHED
}

onready var entity := (get_parent().get_parent() as EntityLiving)

var status = null
var last_pos
var destination
var move_path
var provokes_aoo_on_exit := true
var maximum_movement := -1

signal tile_entered(entity, tile_pos, action)
signal tile_exited(entity, tile_pos, action)


func _ready() -> void:
	traits.append("move")
	set_process(false)

func perform_action(entity, args : Array) -> int:
	status = STRIDE_STATUS.BEGIN
	set_process(true)
	return 1

func _process(delta) -> void:
	match status:
		STRIDE_STATUS.BEGIN: #checks if it's able to do the action
			if not entity is EntityLiving:
				return
			if !entity._can_stride():
				return
			var movement = entity.get_move_speed()
			if(maximum_movement != -1):
				movement = min(maximum_movement, entity.get_move_speed())
			if(movement > 0):
				#adds 1.0 as it starts out expanded by 1
				"""
				TODO move fix to the iso method
				"""
				iso.highlight_area(iso.world_to_map(entity.position), 1, movement+1.0)
				status = STRIDE_STATUS.INPUT
		STRIDE_STATUS.CHECK_VALID:
			var move_path_calc = iso.get_move_path(entity.global_position, destination)
			var cost = iso.compute_cost(move_path_calc)
#			print(cost)
			var movement = entity.get_move_speed()
			if(maximum_movement != -1):
				movement = min(maximum_movement, entity.get_move_speed())
			#adds 0.5 to move speed to allow for a single diagonal movement to only count as 1 move.
			if(cost > movement+.5):
				_reset()
				return
			# is already at the destination
			if move_path_calc.size() <= 1:
				_reset()
				return
			move_path = move_path_calc
			last_pos = entity.position
			status = STRIDE_STATUS.MOVE
		STRIDE_STATUS.MOVE:
			_do_move(max(entity.get_move_speed(),3))
		STRIDE_STATUS.INTERRUPTED:
			status = STRIDE_STATUS.FINISHED
			continue
		STRIDE_STATUS.FINISHED:
			_reset()
		_: 
			return

func _reset() -> void:
	get_parent().get_parent().cur_action = null
	last_pos = null
	status = null
	destination = null
	move_path = null
	status = STRIDE_STATUS.BEGIN
	set_process(false)

func _input(event):
	if(status == STRIDE_STATUS.INPUT):
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT and event.is_pressed():
				destination = get_viewport().get_mouse_position()
				#hide selection area
				iso.clear_highlight()
				status = STRIDE_STATUS.CHECK_VALID

func _do_move(dist : float) -> void:
	if !move_path:
		status = STRIDE_STATUS.FINISHED
		return
	# if leaving a tile
	#the tile_exited signal will be passed to other entities to determine if they can take an Attack of Opportunity
	#with the way this will be setup, if they have a feat to stop movement or succeed in grapple etc, it will interrupt the action
	if entity.position == last_pos:
		emit_signal("tile_exited", entity, iso.world_to_map(entity.position), self)
		move_path.remove(0)
	var dist_to_next = entity.position.distance_to(move_path[0])
	# if it can move towards the destination by dist without ovverunning it
	if dist <= dist_to_next:
		entity.position = entity.position.linear_interpolate(move_path[0], dist / dist_to_next)
		return
	# if it is the last node in the move path it will avoid overunning it
	elif move_path.size() == 1 and dist > dist_to_next:
		status = STRIDE_STATUS.FINISHED
	emit_signal("tile_entered", entity, iso.world_to_map(entity.position), self)
	entity.position = move_path[0]
	last_pos = entity.position