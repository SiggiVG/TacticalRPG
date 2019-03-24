extends Node

enum GAME_STATE {
	PLAYER_TURN,
	AI_TURN
}
export var current_state := GAME_STATE.PLAYER_TURN

onready var tile_map = $World/Navigation2D/TileMap

func _ready() -> void:
	res.initialize()
	dir.initialize()
	dice.initialize()
#	pathfinder.initialize(self)
	iso.set_dungeon(get_node("Dungeon"))
#	get_node("TurnQueue").initialize()
	
func change_dungeon(dungeon) -> void:
	remove_child(get_node("Dungeon")) #todo: save to file
	add_child(dungeon)
	iso.set_dungeon_tile_map(dungeon)