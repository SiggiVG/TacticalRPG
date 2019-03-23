extends Node

class_name Health

var traits : Traits

signal health_changed(amount)
signal max_health_changed(amount)

const BASE_HEALTH = 30
var max_health = BASE_HEALTH
var current_health = max_health

func _ready():
	traits = get_node("../Traits")
	if(traits != null):
		max_health = BASE_HEALTH + traits.get_trait_val(Traits.TRAIT.STR) + traits.get_trait_val(Traits.TRAIT.CON) + traits.get_trait_val(Traits.TRAIT.BUL)
	emit_signal("max_health_changed", max_health)
	emit_signal("health_changed",current_health)
	

func take_damage(amount : int) -> int:
	if(amount >= current_health):
		var damage_taken = current_health;
		current_health = 0;
		emit_signal("health_changed",current_health);
		return damage_taken;
	else:
		current_health -= amount;
		emit_signal("health_changed",current_health);
		return amount;

func rest():
	current_health = max_health
	emit_signal("health_changed",current_health)

func is_alive() -> bool:
	return current_health >= 0

func is_conscious() -> bool:
	return current_health > 0

#
##health bar overlay [ current_health ] [ temp_hp ] [ current_stamina ]
##health bar bg      [ max_health ] [get_max_stamina() ] [wounds]
#
#
#const _MOD_THRESHOLDS = [0,0,1,3,7];
#const _MOD_THRESHOLD_NAMES = ["Uninjured", "Slightly Injured", "Injured", "Severely Injured"];
## greater than key results in val
#const _MODS = {1.25 : [0, "health.rested_well"], 1.001 : [0, "health.rested"], 1 : [0,"health.not_injured"], 0.75 : [0,"health.slightly_injured"], 0.5 : [-1,"health.injured"], 0.25 : [-3,"health.seriously_injured"], 0 : [-7,"health.critically_injured"], -1 : [-25,"health.dying"], -2 : [-25, "health.dead"]};
#
#const BASE_HEALTH = 30;
#
#var _is_alive = true;
#
#var max_health = BASE_HEALTH;
#var current_health = max_health;
##temp_hp? probably dealt after stamina, and would have the ability to wound just like normal hp. does not calculate into damage thresholds
#var temp_hp = 0;
#var temp_hp_source = "";
#var wounds = 0;
#var wound_recovery_rate = 3; # con
#var wound_chance = 10 - wound_recovery_rate;
#var recover_chance = 10;
#var current_stamina = get_max_stamina();
#
#var resistances = {};
#
#func grant_temp_hp(amount, source, additional_effects):
#	if(source == temp_hp_source): temp_hp += amount;
#	if(additional_effects): temp_hp = amount;
#	temp_hp = max(temp_hp, amount);
#
## returns damage actually dealt
#func take_damage(amount, can_wound, type):
#	if(resistances.has(type)):
#		amount -= resistances[type];
#	if(amount > 0):
#		return _take_damage_unmitigated(amount, can_wound);
#	return 0; # either amount was negative or fully resisted
#
## returns damage actually dealt
## damage type doesn't matter, as it's unmitigated
#func _take_damage_unmitigated(amount, can_wound):
#	if(amount <=0):
#		return 0;
#	if(amount <= current_stamina):
#		current_stamina -= amount;
#		return amount;
#	if(can_wound): #wounds are never dealt while stamina remains.
#		if(rand_range(1,21) >= wound_chance):
#			wounds += 1;
#	var damage_taken = current_stamina;
#	current_stamina = 0;
#	amount -= damage_taken;
#	if (temp_hp > 0):
#		if(amount >= temp_hp):
#			damage_taken += temp_hp;
#			amount -= temp_hp;
#			temp_hp = 0;
#		else:
#			temp_hp -= amount;
#			return amount + damage_taken;
#	if(amount >= current_health):
#		if (amount >= current_health + max_health): # dealt enough damage to outright kill the creature
#			set_dead();
#		damage_taken += current_health;
#		current_health = 0;
#		return damage_taken;
#	else:
#		current_health -= amount;
#		return damage_taken + amount;
#	return 0;
#
#func is_alive():
#	return _is_alive;
#
#func is_conscious():
#	return _is_alive && current_health <= 0; #todo: rage override
#
#func is_dying():
#	return _is_alive && current_health < 0;
#
#func set_dead():
#	_is_alive = false;
#
#func get_max_stamina():
#	return (max_health / 4) - wounds;
#
##length - 0 exits, 1 is pause (10 minutes), 2 is short (60 minutes, 1 hour), 3 is long (8 hours), 4 is recovery (24 hours, 1 day), 5 is extended (7 days, 1 week);
#func rest(length):
#	if(length <= 0): pass;
#	match length:
#		1: #recovers stamina only
#			print("takes a breather");
#		2: #recover 1 wound based on a recovery roll
#			print("takes a short rest");
#			if(wounds > 0 && rand_range(1,21)>=recover_chance): wounds -= 1; #todo - recovery roll
#		3: #recover hp based on con, etc. garunteed 1 wounds recovery, chance to recover more with recovery roll, up to con #. requires a camp. limited to once every 24 hours
#			print("makes camp and turns in");
#			if(wounds > 0): wounds -= 1;
#			for i in range(wound_recovery_rate-1):
#				if(wounds > 0 && rand_range(1,21)>=recover_chance): wounds -= 1; #todo - recovery roll
#			current_health = min(current_health + wound_recovery_rate, max_health);
#		4: #requires a proper bed, not just a camp.
#			print("spends all day in bed");
#			if(wounds > 0): wounds -= wound_recovery_rate;
#			for i in range(1,wound_recovery_rate+1):
#				if(wounds > 0 && rand_range(1,21)>=recover_chance): wounds -= rand_range(1,wound_recovery_rate+1); #todo - recovery roll
#			current_health = max_health;
#		5: #can only be done in full settlements. considered downtime.
#			wounds = 0;
#			current_health = max_health;
#	if(wounds < 0): wounds = 0;
#	current_stamina = get_max_stamina();
#	temp_hp = 0;
#	pass;
#
#func get_status():
#	if(is_alive()):
#		if(is_dying()): return "Dying";
#		elif(current_stamina >= get_max_stamina()):
#			if(current_health >= max_health):
#				return "Well Rested";
#			else: return "Rested";
#		if(current_stamina == 0 && current_health == max_health):
#			return "Winded";
#		elif(current_health == max_health):
#			return _MOD_THRESHOLD_NAMES[0];
#		elif(current_health >= max_health * 0.75):
#			return _MOD_THRESHOLD_NAMES[1];
#		elif(current_health >= max_health * 0.5):
#			return _MOD_THRESHOLD_NAMES[2];
#		elif(current_health >= max_health * 0.25):
#			return _MOD_THRESHOLD_NAMES[3];
#		elif(current_health > 0):
#			return _MOD_THRESHOLD_NAMES[4];
#		elif(!is_conscious()): return "Unconscious";
#		return "ERROR - HEALTH STATUS";
#	else: return "Dead";
#
#
#func get_mod_adjust():
#	if(current_health == max_health):
#		return _MOD_THRESHOLDS[0];
#	elif(current_health >= max_health * 0.75):
#		return _MOD_THRESHOLDS[1];
#	elif(current_health >= max_health * 0.5):
#		return _MOD_THRESHOLDS[2];
#	elif(current_health >= max_health * 0.25):
#		return _MOD_THRESHOLDS[3];
#	elif(current_health > 0):
#		return _MOD_THRESHOLDS[4];
#	elif(current_health <= 0):
#		return 0; # can't act, so it doesn't matter
#	return 0;
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if(current_stamina > get_max_stamina()):
#		current_stamina = get_max_stamina();