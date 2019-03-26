extends Node

class_name Action

onready var _actions_to_perform := 1
export var traits := []

func perform_action(entity, args : Array):
	return 0
	"""
	Entities will have a child that contains a list of actions (and activities, reactions) 
	that they can perform.
	basic actions are actions that are added to all living entities

	@return the number of actions taken (in case it gets interupted)
	"""