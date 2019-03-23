extends Node

enum GAME_STATE {
	PLAYER_TURN,
	AI_TURN
}
export var current_state := GAME_STATE.PLAYER_TURN


func _ready() -> void:
	res.initialize()
	dir.initialize()
	dice.initialize()
	get_node("TurnQueue").initialize()