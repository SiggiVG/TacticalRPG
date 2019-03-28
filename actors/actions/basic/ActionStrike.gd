extends Action

class_name ActionStrike


#onready var entity := (get_parent().get_parent() as EntityLiving)

var target_loc = null
var target = null

func _ready() -> void:
	traits.append("attack")
	set_process(false)

func perform_action(entity, args : Dictionary) -> int:
	action_status = Action.STATUS.INITIATE
	set_process(true)
#	print("actionstrike force go!")
	yield()
	print(action_status)
	if action_status == Action.STATUS.FINISHED:
		_reset()
		return -1
	return 0
	
func _process(delta) -> void:
#	print(action_status)
	match action_status:
		Action.STATUS.INITIATE: #checks if it's able to do the action
			d_map.highlight_area(entity.global_position, 1, true, entity.reach+0.5, true, true, true)
			action_status = Action.STATUS.INPUT
		Action.STATUS.CHECK_VALID:
			if d_map.world_to_map(target_loc).distance_to(d_map.world_to_map(entity.position)) > entity.reach:
				_reset()
				print (str("Entity ", entity.name, " is too far from ", target_loc, " to strike!"))
				return
			if not (find_parent("Entities") as EntityList).is_entity_at(target_loc, true):
#				print ("slutty brownie")
				_reset()
				return
			target = (find_parent("Entities") as EntityList).get_entity_at(target_loc, true)
			if !target or target == entity:
#				print ("bepis")
				_reset()
				return
			
			action_status = Action.STATUS.DO_ACTION
		Action.STATUS.DO_ACTION:
			print (str("Damage Dealt: ", target.take_damage("generic",dice.roll_damage())))
			action_status = Action.STATUS.FINISHED
		Action.STATUS.INTERRUPTED:
			_reset()
			pass
		Action.STATUS.FINISHED:
			pass
			
func _reset() -> void:
	get_parent().get_parent().cur_action = null
	target = null
	action_status = Action.STATUS.INTERRUPTED
	set_process(false)
	
func _input(event):
	if(action_status == Action.STATUS.INPUT):
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT and event.is_pressed():
				target_loc = get_viewport().get_mouse_position()
				#hide selection area
				d_map.clear_highlight()
#				print("stride checking valid")
				action_status = Action.STATUS.CHECK_VALID