extends Node

class_name Morale

const MORALE_INCREMENT = 10

var fear = 0
var courage = 0

signal fear_changed(amount);
signal courage_changed(amount);

func _ready():
	emit_signal("fear_changed",fear);
	emit_signal("courage_changed",courage);

func add_fear(amount : int) -> int:
	fear += amount
	emit_signal("fear_changed",fear);
	return amount
	
func add_courage(amount : int) -> int:
	courage += amount
	emit_signal("courage_changed",courage);
	return amount

#TODO: fear and courage removal on a rest

func get_activity_mod():
	return -(fear / MORALE_INCREMENT) + (courage / MORALE_INCREMENT)

func time_pass(emit_signals := false):
	fear = max(0, fear - dice.roll10())
	courage = max(0, courage - dice.roll10())
	if(emit_signals):
		emit_signal("fear_changed",fear);
		emit_signal("courage_changed",courage);

func rest(type, include_lesser := false):
	match type:
		Living.REST_TYPE.EXTENDED:
			for i in range(7):
				time_pass()
			if(include_lesser): continue
			else:
				emit_signal("fear_changed",fear);
				emit_signal("courage_changed",courage);
		Living.REST_TYPE.BED: 
			time_pass(!include_lesser)
			if(include_lesser): continue
		Living.REST_TYPE.LONG: 
			time_pass(!include_lesser)
			if(include_lesser): continue
		Living.REST_TYPE.SHORT: 
			time_pass(!include_lesser)
			if(include_lesser): continue
		Living.REST_TYPE.BREATH: 
			time_pass(true)

#const _MOD_THRESHOLDS = [0,0,1,3,7];
#
#const _THRESHOLD = 10;
#
#var terror_points = 0;
#var courage_points = 0;
#
#func get_morale():
#	var steps = 0;
#	if(terror_points > 0):
#		steps -= terror_points / _THRESHOLD;
#	if(courage_points > 0):
#		steps += courage_points / _THRESHOLD;
#	return steps;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
