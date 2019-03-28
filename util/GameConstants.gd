extends Node

"""
size of cells on the zoomed out dungeon map
"""
const CELL_SIZE := Vector2(96,48)#64,32)
#"""
#size of cells on the zoomed in dungeon map
#"""
#const ZOOM_CELL_SIZE := Vector2(128,64)
"""
true if pathfinding can path to tiles it shares an edge with
"""
const PATH_CARDINAL := true
"""
true if pathfinding can path to tiles it shares an corner with
"""
const PATH_INTERCARDINAL := true

const REACH_CARDINAL := true
const REACH_INTERCARDINAL := true

"""
the cost in movement tiles of moving to a cardinally adjacent tile
"""
const CARDINAL_COST := 1.0
"""
the cost in movement tiles of moving to an intercardinally adjacent tile
"""
const INTERCARDINAL_COST := 1.5

"""
Tile Size window size constants
based on bounds in fullsize/zoomed out coords
"""
#x + y < 9 -> return
#y-10 > x -> return
#x-10 > y -> return
#x + y > 32 -> return