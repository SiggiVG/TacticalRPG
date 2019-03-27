extends Node

class_name Action

onready var _actions_to_perform := 1
export var traits := []

onready var d_map := find_parent("Main").find_node("DungeonMap") as DungeonMap

enum STATUS {
	BEGIN,
	INPUT,
	CHECK_VALID,
	DO_ACTION
	INTERRUPTED,
	FINISHED
}
var action_status = null

func perform_action(entity, args : Dictionary):
	"""
	Entities will have a child that contains a list of actions (and activities, reactions) 
	that they can perform.
	basic actions are actions that are added to all living entities

	@return the number of actions taken (in case it gets interupted)
	"""
	return 0