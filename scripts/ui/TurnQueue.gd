extends Control

class_name TurnQueue

export var offset_x := 64
export var offset_y := 0

export var path_to_entities := "Entities"

var active_character : EntityLiving setget set_active_character, get_active_character

func initialize():
#	print(str(name," ",position))
	generate_sprites()
	roll_initiative()
#	active_character = get_child(0).name
	for i in range(get_child_count()):
		print(str(get_child(i).name," rolled an initiative of ",get_character(get_child(i).name).initiative))

func set_active_character(character) -> void:
	if character is String:
		character = get_character(character)
	active_character = character
	
func get_active_character(as_string := false):
	if as_string:
		return active_character.name
	return active_character

func get_character(name : String) -> Node:
	return get_parent().find_node(path_to_entities).get_node(name)

func set_sprite_has_taken_turn(character) -> void:
	if character is String:
		character = get_character(character)
	

func roll_initiative() -> void:
	print ("ROLL INITIATIVE")
	for battler in get_battlers():
		battler.roll_initiative()
	sort_battlers()
	arrange_sprites()
	set_active_character(get_child(0).name)

func sort_battlers() -> void:
	var battlers = get_battlers()
	battlers.sort_custom(self, 'sort_by_initiative')
	for i in battlers.size():
		var battler = get_node(battlers[i].name)
		if(battler != null):
			battler.raise()
#			battler.position.x = 64 * i

func arrange_sprites(offsetx := offset_x, offsety := offset_y) -> void:
	for i in get_child_count():
		var sprite = get_child(i)
		if(sprite is Sprite):
#			sprite.modulate.r -= i/5.0
#			sprite.modulate.g += i/5.0
#			sprite.modulate.b -= i/5.0
			sprite.position.x = (offsetx * i)
			sprite.position.y = (offsety * i)
	
	
func sort_by_initiative(a : Node, b : Node) -> bool:
	#todo: check is ==, and if so, highest dex goes first or player goes first
	return a.initiative > b.initiative

func generate_sprites() -> void:
	#adds new sprites
	var battlers = get_battlers()
	for i in range(battlers.size()):
		var cur_battler = battlers[i].get_node("Portrait").duplicate()
#		var cur_battler := Sprite.new()
		cur_battler.name = battlers[i].name
		cur_battler.visible = true
#		cur_battler.texture = battlers[i].get_node("Portrait").texture
#		print(cur_battler.get_child_count())
		add_child(cur_battler)

func clear_sprites() -> void:
	# deletes all sprites
	for child in get_children():
		if child is Sprite:
			child.queue_free()

func get_battlers() -> Array:
	var temp = get_parent().find_node(path_to_entities).get_children()
	var battlers = []
	#ensure that each child is an instance of living and thus has an initiative method
	for each in temp:
		if each.get_node("Living") != null:
			battlers.append(each)
#	print(battlers)
	return battlers