extends Node

class_name Action

onready var _actions_to_perform := 1

signal action_state

func _perform_action(entity : Entity, args := []) -> int:
	"""
	Entities will have a child that contains a list of actions (and activities, reactions) 
	that they can perform.
	basic actions are actions that are added to all living entities
	
	@return the number of actions taken (in case it gets interupted)
	"""
	var initiate = _initiate_action(args)
	
	
	
	return _actions_to_perform
	

func _initiate_action(args : Array = []) -> int:
	yield()
	return _actions_to_perform

func _on_action_initiated(args : Array = []) -> bool:
	
	return true

func _complete_action(args : Array = []) -> int:
	yield()
	return _actions_to_perform

func _on_action_completed(args : Array = []) -> bool:
	
	return true

func _interrupt_action(args : Array = []) -> int:
	yield()
	return _actions_to_perform

func _on_action_interrupted(args : Array = []) -> bool:
	
	return true