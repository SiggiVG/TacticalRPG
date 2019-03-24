extends "res://actors/EntityLiving.gd"

class_name EntityHumanoid

onready var humanoid_body := $Living/Body/HumanoidBody

var is_active_character := true

func _unhandled_input(event):
	if not is_active_character:
		return
	if not event is InputEventMouseButton:
		return
#	var mp = get_viewport().get_mouse_position()
#	if(mp.x > position.x - 20 and mp.y > position.y -20 and mp.x < position.x+20 and mp.y < position.y+20):
#		print("fart")
	if not event.pressed:
		return
	if event.button_index == BUTTON_LEFT:
		var dest = get_viewport().get_mouse_position()
		set_destination(get_viewport().get_mouse_position())

#		print(living.move_path.size())
		if(_movement_path.size() > 1):
			get_tree().set_input_as_handled()
	if event.button_index == BUTTON_RIGHT:
		if(has_item(0)):
			drop_item(0)
			get_tree().set_input_as_handled()
		elif(has_item(1)):
			drop_item(1)
			get_tree().set_input_as_handled()

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


