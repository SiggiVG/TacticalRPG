extends Area2D

signal entity_clicked(button_index)

func _input_event(viewport, event : InputEvent, shape_idx):
	if event is InputEventMouseButton: 
		if event.button_index == BUTTON_LEFT and event.is_pressed():
			emit_signal("entity_clicked", BUTTON_LEFT)
			get_tree().set_input_as_handled()
		