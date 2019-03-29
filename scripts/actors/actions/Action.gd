extends Node

class_name Action

onready var entity := (get_parent().get_parent())

onready var _actions_to_perform := 1
export var traits := []

onready var d_map := find_parent("Main").find_node("DungeonMap") as DungeonMap

enum STATUS {
	CANCELED
	INITIATE,
	INPUT,
	CHECK_VALID,
	DO_ACTION
	INTERRUPTED,
	FINISHED
}
var action_status = null

func _perform_action(entity, args : Dictionary):
	"""
	Entities will have a child that contains a list of actions (and activities, reactions) 
	that they can perform.
	basic actions are actions that are added to all living entities

	@return the number of actions taken (in case it gets interupted)
	"""
	action_status = STATUS.INITIATE
	set_process(true)
	yield()
	if action_status == STATUS.FINISHED || action_status == STATUS.INTERRUPTED:
		_reset()
		return _actions_to_perform
	return 0

func _add_trait(trait : String) -> void:
	if not trait in traits:
		traits.append(trait)

func _process(delta) -> void:
	match action_status:
		STATUS.INITIATE: #checks if it's able to do the action
			if _on_initiated():
				action_status = STATUS.INPUT
		STATUS.CHECK_VALID:
			if _check_valid():
				action_status = STATUS.DO_ACTION
#			else:
#				action_status = STATUS.INPUT
		STATUS.DO_ACTION:
			if _do_action():
				action_status = STATUS.FINISHED
		STATUS.INTERRUPTED:
			_on_interrupted()
			pass
		STATUS.FINISHED:
			_on_finished()
			pass
		STATUS.CANCELED:
			_on_canceled()
			_reset()


func _on_initiated() -> bool:
	return true

func _input(event):
	pass
#	action_status = STATUS.CHECK_VALID

func _check_valid() -> bool:
	return true

func _do_action() -> bool:
	return true

func _on_interrupted() -> bool:
	return true

func _on_finished() -> bool:
	return true

func _on_canceled() -> bool:
	return true

func _reset() -> void:
	get_parent().get_parent().cur_action = null
	action_status = null
	set_process(false)