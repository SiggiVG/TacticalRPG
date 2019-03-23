extends Node

class_name DiceRoller

func initialize():
	randomize()

func roll(amount := 1, size := 20, mod := 0, explode_on := -1) -> int:
	var result : int = 0
	for i in range(amount):
		var cur = rand_range(0,size) + 1
		result += cur
		while(explode_on != -1 and cur >= explode_on): #is exploding
			cur = rand_range(0,size) + 1
			result += cur
	return result + mod

func roll20(mod := 0) -> int:
	return roll(1,20,mod)

func roll12(mod := 0) -> int:
	return roll(1,12,mod)

func roll10(mod := 0) -> int:
	return roll(1,10,mod)

func roll8(mod := 0) -> int:
	return roll(1,8,mod)

func roll6(mod := 0) -> int:
	return roll(1,6,mod)

func roll5(mod := 0) -> int:
	return roll10() / 2 + mod

func roll4(mod := 0) -> int:
	return roll(1,4,mod)

func roll3(mod := 0) -> int:
	return roll6() / 2 + mod  

func roll100(mod := 0) -> int:
	var res = ((roll10() % 10) * 10) + (roll10(mod) % 10)
	if(res == 0): return 100
	return res

func roll_sv(target_sv := 1, return_result := false):
	var roll = roll20()
	if(return_result):
		return roll
	return roll <= target_sv

func roll_damage(type := "generic", amount := 1, mod := 0, explode_on := 10):
	var size := 10
	if("unarmed" in type): #unarmed attacks always use a d10/2, usually explode on a 10, like light weapons do
		size = 5
	elif("cantrip" in type): #cantrips deal less damage than spells with a tier, never explode
		size = 6
		explode_on = -1
	elif("spell" in type): #spells use a d8
		size = 8
	return roll(amount,size,mod,explode_on)
