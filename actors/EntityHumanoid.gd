extends "res://actors/EntityLiving.gd"

class_name EntityHumanoid

onready var humanoid_body := $Living/Body/HumanoidBody

export var is_player_controlled := false
export var is_active_character := false
onready var actions := $Actions

func _ready() -> void:
	._ready()

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

var action_status

func _process(delta) -> void:
	if is_active_character:
#		print (get_actions().get_child(0))
#		print (actions.get_child(0).action_status)
		if !cur_action:
			set_process(false)
			action_status = null
			return
		if cur_action.action_status == Action.STATUS.FINISHED or cur_action.action_status == Action.STATUS.INTERRUPTED:
			print (cur_action.name)
			actions_remaining += action_status.resume()
			action_status = null
			set_process(false)
	else:
		set_process(false)

func _on_entity_selected():
	if is_active_character:
		if actions_remaining > 0:
			cur_action = actions.get_node("ActionStrike")
			action_status = cur_action.perform_action(self, {"position" : position, "actions_remaining" : actions_remaining})
			set_process(true)
		else:
			is_active_character = false
			set_process(false)
