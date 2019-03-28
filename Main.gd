extends Node

enum GAME_STATE {
	PLAYER_TURN,
	AI_TURN
}
#export var current_state := GAME_STATE.PLAYER_TURN

#onready var tile_map = $World/Navigation2D/TileMap

signal on_tile_clicked(mouse_button, map_pos, tile_type)

func _ready() -> void:
	res.initialize()
	dir.initialize()
	dice.initialize()
	iso.set_dungeon(get_node("Dungeon"))
#	get_node("TurnQueue").initialize()
	
func change_dungeon(dungeon) -> void:
	remove_child(get_node("Dungeon")) #todo: save to file
	add_child(dungeon)
	iso.set_dungeon_tile_map(dungeon)

func _on_TileMap_on_tile_clicked(mouse_button, world_pos : Vector2, tile_type : String):
	emit_signal("on_tile_clicked",mouse_button, world_pos, tile_type)

func _unhandled_input(event):
	pass
