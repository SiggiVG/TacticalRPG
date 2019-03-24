extends Node2D

class_name Entity

onready var sprite := $Sprite

var has_used_reaction := false

signal on_enter_cell

func _on_initiative_20() -> bool:
	"""
	a virtual function that is called the initiative count of 20
	this is used by nonliving entities (such as traps) to perform their actions
	"""
	return true