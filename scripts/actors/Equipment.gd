extends Node

var body_type

func _ready() -> void:
	body_type = find_parent("Living").find_node("Body").get_child(0)
#	get_node("../../Body").get_child(0)
	if body_type == null:
		print(str("Entity ", get_parent().get_parent().name, " is broken"))
		return
	generate_equipment_slots()

func generate_equipment_slots() -> void:
	#is bodytime has parts
	if body_type.get_child_count() > 0:
		for part in body_type.get_children():
			#if part doesnt already exist, generate it
			if get_node(part.name) == null:
				var node : Node = part.duplicate()
				self.add_child(node)