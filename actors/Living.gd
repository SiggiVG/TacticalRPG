extends Node

class_name Living

enum REST_TYPE {
	BREATH, SHORT, LONG, BED, EXTENDED
}

onready var traits := $Traits

var initiative

func roll_initiative() -> int:
	initiative = dice.roll20(traits.get_trait_val("dex") - traits.get_trait_val("bul"))
	return initiative