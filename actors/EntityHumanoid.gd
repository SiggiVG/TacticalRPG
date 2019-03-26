extends "res://actors/EntityLiving.gd"

class_name EntityHumanoid

onready var humanoid_body := $Living/Body/HumanoidBody

var is_active_character := true

#func _unhandled_input(event):
#	if not is_active_character:
#		return
#	if not event is InputEventMouseButton:
#		return
##	var mp = get_viewport().get_mouse_position()
##	if(mp.x > position.x - 20 and mp.y > position.y -20 and mp.x < position.x+20 and mp.y < position.y+20):
##		print("fart")
#	if not event.pressed:
#		return
#	if event.button_index == BUTTON_LEFT:
#		find_node("ActionStride").perform_action(global_position, max_move_tiles)
		#TODO: move to stride action
#		if show_move_range:
##			iso.clear_highlight()
##			iso.highlight_area(iso.world_to_map(global_position), 0, max_move_tiles, false)
#	#		show_move_range = false
##			var dest = get_viewport().get_mouse_position()
##			set_destination(get_viewport().get_mouse_position())
#			show_move_range = false
#		else:
##			iso.highlight_area(iso.world_to_map(global_position), 1, max_move_tiles, false)
#			show_move_range = true

#		print(living.move_path.size())
#			if(_movement_path.size() > 1):
#				get_tree().set_input_as_handled()
#	if event.button_index == BUTTON_RIGHT:
#		if(has_item(0)):
#			drop_item(0)
#			get_tree().set_input_as_handled()
#		elif(has_item(1)):
#			drop_item(1)
#			get_tree().set_input_as_handled()

func get_hand(hand):
	return get_node(str("Living/Inventory/Equipment/","Hand",hand_name(hand)))

func hand_name(hand) -> String:
	var which : String
	if hand is int:
		match hand:
			0: which = "Weapon"
			1: which = "Shield"
	elif hand is String:
		which = hand.capitalize()
	return which

func has_hand(hand) -> bool:
	var handy = get_hand(hand) 
	if(handy == null):
		print(str(name,"'s Hand called Hand",hand_name(hand)," not found..."))
		return false
	return true

func has_item(hand) -> bool:
	if(!has_hand(hand)):
		return false
	var handy = get_hand(hand)
	var item = handy.get_child(0)
	if(item == null):
		print(str(name,"'s Hand called Hand",hand_name(hand)," is not holding an item..."))
		return false
	return true
	
func drop_item(hand):
	if has_hand(hand) and has_item(hand):
		var handy = get_hand(hand)
		var item = handy.get_child(0)
		handy.remove_child(item)
	#	item.show()
		print(str(name,"'s Hand called Hand",hand_name(hand)," has dropped the item called ",item.name))
		find_parent("Main").find_node("Dungeon").add_item_to_world(item, global_position)

#func _on_Main_on_tile_clicked(mouse_button, world_pos : Vector2, tile_type : String):
#	"""
#	TODO: move to stride action
#	"""
#	if mouse_button == BUTTON_LEFT:
#		if show_move_range and "Red" in tile_type:
#			get_node("Actions/ActionStride").perform_action()
#		iso.clear_highlight()
#		show_move_range = false

func _on_entity_selected() -> bool:
	var sup = ._on_entity_selected()
	#todo: move to EntityPlayer and do UI
	#currently defaults to striding
	var action_status = get_node("Actions/ActionStride").perform_action(self, [position, actions_left])
	actions_left -= action_status
#	if(not action_status is int and not action_status == null):
#		action_status.resume()
#	actions_left -= action_status
	return sup or bool(action_status)
