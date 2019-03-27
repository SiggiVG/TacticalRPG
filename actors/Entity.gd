extends Node2D

class_name Entity

onready var sprite := $Sprite

var has_used_reaction := false
var cur_action : Action

signal on_enter_cell

func _ready():
	set_process(false)

func _begin_turn() -> void:
	
	pass

func _can_stride() -> bool:
	return false

func _on_initiative_20() -> bool:
	"""
	a virtual function that is called the initiative count of 20
	this is used by nonliving entities (such as traps) to perform their actions
	"""
	return true

func _on_entity_selected():
	return

func _on_EntityArea_entity_clicked(button_index):
	if not button_index == BUTTON_LEFT:
		return
	_on_entity_selected()
	
	get_tree().set_input_as_handled()