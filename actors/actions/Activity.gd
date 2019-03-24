extends Action

class_name Activity

var _actions : Array

func _ready() -> void:
	"""
	@method _ready
	sets the activity's actions to be its children that are actions
	and, if no @var _actions_to_perform is set in the editor (ie it == 0),
	then it sets @var _actions_to_perform to the @method size() of @var _actions
	
	in future, might remove the ability to have Reactions be part of activities
	"""
	_actions = []
	for c in self.get_children():
		if c is Action:
			_actions.append(c)
	if !_actions_to_perform:
		_actions_to_perform = _actions.size()

