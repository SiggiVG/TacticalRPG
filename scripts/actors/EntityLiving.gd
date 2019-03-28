extends Entity

"""
Represents an entity which has a semblence of autonomy
They can move while having a destination and could have AI associated with them
They can take basic actions such as Stride, Step, Strike
"""

onready var portrait := $Portrait
onready var health := $Living/Health
onready var traits := $Living/Traits
onready var morale := $Living/Morale
onready var inventory := $Living/Inventory
onready var body := get_node("Living/Body").get_child(0)

signal on_entity_enter_tile(entity, world_position, action_used)

var acceleration := 0
var slowness := 0

enum REST_TYPE {
	BREATH, #10 minutes, recover stamina
	SHORT, #1 hour, spent eating/cleaning wounds/etc
	LONG, #8 hours, a night's rest
	BED, #24 hours, spent in bed
	EXTENDED #one week, used to learn new skills & level up
}

export var max_move_tiles := 5
export var reach := 1

var actions_remaining := 3
var reactions_remaining := 1

var initiative : int

func _ready():
	._ready()
#	$EntityArea.connect("mouse_exited", self, "_on_EntityArea_mouse_exited")
	$EntityArea.connect("entity_clicked", self, "_on_EntityArea_entity_clicked")
	pass

func _begin_turn() -> void:
	actions_remaining = 3
	reactions_remaining = 1

func roll_initiative() -> int:
	initiative = dice.roll20(traits.get_trait_val("dex") - traits.get_trait_val("bul"))
	return initiative

func get_move_speed() -> int:
	"""
	@returns the amount of tiles that the entity is currently able to move in a single stride action
	"""
	return int(max(0,max_move_tiles + acceleration - slowness))

func take_damage(type := "generic", amount := 1) -> int:
	var dam =  health.take_damage(amount)
	if(health.current_health <= 0):
		print (str(name, " has been slain!"))
	return dam

func _process(delta) -> void:
	pass
func get_max_move_tiles() -> int:
	return max_move_tiles

func _can_stride() -> bool:
	return max_move_tiles > 0
func _on_entity_selected() -> bool:
#	print(str(name," has been selected"))
	return true