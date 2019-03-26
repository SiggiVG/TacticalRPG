extends TileMap

signal on_tile_clicked(mouse_button, world_pos, tile_type)

func _ready() -> void:
	pass

#func _input(event : InputEvent):
#	if event is InputEventMouseButton:
#		if event.button_index == BUTTON_LEFT and event.is_pressed():
#			var pos = world_to_map(event.position)
#			var tile = tile_set.
#			print(str("Tile Clicked - ",pos, " ", tile_set.tile_get_name(get_cell(pos.x,pos.y))))
#			emit_signal("on_tile_clicked", BUTTON_LEFT, event.position, tile_set.tile_get_name(get_cell(pos.x,pos.y)))
#			get_tree().set_input_as_handled()