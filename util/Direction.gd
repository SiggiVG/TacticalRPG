extends Node

func initialize() -> void:
	pass

const CENTER	= Vector2(0,0)
const NORTH		= Vector2(0,-1)
const EAST		= Vector2(1,0)
const SOUTH		= Vector2(0,1)
const WEST		= Vector2(-1,0)

const NORTH_EAST = NORTH + EAST
const SOUTH_EAST = SOUTH + EAST
const SOUTH_WEST = SOUTH + WEST
const NORTH_WEST = NORTH + WEST

func rand_cardinal() -> Vector2:
	match dice.roll4():
		1: return NORTH
		2: return EAST
		3: return SOUTH
		4: return WEST
		_: return CENTER

func rand() -> Vector2:
	match dice.roll8():
		1: return NORTH
		2: return EAST
		3: return SOUTH
		4: return WEST
		5: return NORTH_EAST
		6: return SOUTH_EAST
		7: return SOUTH_WEST
		8: return NORTH_WEST
		_: return CENTER

func is_cardinal(dir : Vector2) -> bool:
	match dir:
		NORTH,EAST,SOUTH,WEST: return true
	return false

func is_intercardinal(dir: Vector2) -> bool:
	match dir:
		NORTH_EAST,SOUTH_EAST,SOUTH_WEST,NORTH_WEST: return true
	return false

func ordinal(dir : Vector2) -> float:
	match dir:
		NORTH:		return 1.0
		EAST:		return 2.0
		SOUTH:		return 3.0
		WEST:		return 4.0
		NORTH_EAST:	return 1.5
		SOUTH_EAST:	return 2.5
		SOUTH_WEST:	return 3.5
		NORTH_WEST:	return 4.5
	return 0.0
		
func axis(dir : Vector2) -> String:
	match dir:
		NORTH,SOUTH: return "y"
		EAST,WEST: return "x"
		_: return "xy"