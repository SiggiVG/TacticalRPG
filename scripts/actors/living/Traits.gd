extends Node

class_name Traits

const MIN_BASE = -4
const MAX_BASE = 4

enum TRAIT {
	#physical traits, effected by ancestry
	STR, #strength - effects hit points, damage, carry capacity
	DEX, #dexterity - effects finesse, move speed, initiative, dodge, and resistance to dodgable maneuvers
	CON, #constitution - effects hit points and resistance to physical ailments and wounds
	BUL, #size - effects hit points, carry capacity, initiative & ability to dodge (negatively), and resistance to athletic maneuvers
	#studied traits
	INT, #intellect - effects arcane spellcasting, reasoning, ability to recall knowledge, and ability to learn (such as spells and maneuvers).
	WIL, #willpower - effects resistance to emotional, mental effects, terror (negative changes to morale), and determines heightening of arcane spells
	#faith traits
	DEV, #devotion - effects divine spellcasting and courage (positive changes to morale)
	FAV, #favor - effects luck and determines heightening of divine spells
	#seeming traits
	CHA, #charisma - effects interactions, physical appearence, prices, and occult spell casting
	ATT, #attunement - effects ability to activate magic itmes and determines heightening of occult spells
	#perception
	PER #perception - effects ability to percieve surroundings
	#intuition?
}

export (Dictionary) var traits : Dictionary = {
	TRAIT.STR : 0,
	TRAIT.DEX : 0,
	TRAIT.CON : 0,
	TRAIT.INT : 0,
	TRAIT.WIL : 0,
	TRAIT.PER : 0,
	TRAIT.CHA : 0,
	TRAIT.ATT : 0,
	TRAIT.DEV : 0,
	TRAIT.FAV : 0,
	TRAIT.BUL : 0,
}

# "trait_name ": [amount,source,duration]
var temp_trait_mods : Dictionary = {}

func get_trait_val(trait) -> int:
	if trait is String:
		match trait:
			"strength","str": trait = TRAIT.STR
			"dexterity","dex": trait = TRAIT.DEX
			"constitution","con": trait = TRAIT.CON
			"bulk","bul": trait = TRAIT.BUL
			"intellect","int": trait = TRAIT.INT
			"willpower","wil": trait = TRAIT.WIL
			"devotion","dev": trait = TRAIT.DEV
			"favor","fav": trait = TRAIT.FAV
			"charisma","cha": trait = TRAIT.CHA
			"attunement","att": trait = TRAIT.ATT
			"perception","per": trait = TRAIT.PER
			_: return 0
	if(trait in TRAIT):
		return traits[trait]
	return 0

func get_trait_name(trait) -> String:
	if(trait in TRAIT):
		match trait:
			TRAIT.STR: return "strength"
			TRAIT.DEX: return "dexterity"
			TRAIT.CON: return "constitution"
			TRAIT.BUL: return "bulk"
			TRAIT.INT: return "intellect"
			TRAIT.WIL: return "willpower"
			TRAIT.DEV: return "devotion"
			TRAIT.FAV: return "favor"
			TRAIT.CHA: return "charisma"
			TRAIT.ATT: return "attunement"
			TRAIT.PER: return "perception"
			_: return ""
	return ""