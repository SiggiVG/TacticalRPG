extends Action

func _perform_action(entity : Entity, args := []) -> int:
	"""
	@param entity must be EntityLiving to Stride
	@param args[0] is the destination
	"""
	if (not args[0] is Vector2) or (not entity is EntityLiving):
		return 0
	if not entity.can_stride():
		return 0
	var movement = (entity as EntityLiving).get_max_move_tiles()
	if(movement > 0):
		var move_path = iso.get_move_path(entity.global_position, get_viewport().get_mouse_position())
		((entity as EntityLiving).get_node("Living") as Living).move_path = move_path
	else:
		return 0
		
	return 0