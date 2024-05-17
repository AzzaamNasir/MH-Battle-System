extends Node

signal selectActivated(minion,targets,targeter)
signal move_complete

var targeter
var selectMode : bool = false
var target : int
var targetChooser : int
var targetNo : int
var targets_to_get : int:
	set(new_val):
		targets_to_get = new_val
		if new_val == 0 and moveEffect.targetSelector != 1:
			_hit_targets()
var moveEffect : MoveEffects
var attempting
var attemptor : Node2D = null
var hitlist : Array = []

enum targetSelectors{
	Player,
	Random,
	All
}

enum targetType{
	Enemy,
	Ally,
	Self
}

func activateSelectMode(minion, effect : MoveEffects,team1 : Array[Minion],team2 : Array[Minion]):
	moveEffect = effect
	targeter = minion
	target = effect.target
	targetChooser = effect.targetSelector
	targetNo = effect.targetNo
	selectMode = true
	targets_to_get = targetNo
	match effect.targetSelector:
		1:
			if effect.target == 0:
				_select_hitlist(minion,team1,team2)
		_:
			emit_signal("selectActivated",minion,target,targeter.get_meta("Team"))

func _process(delta: float) -> void:
	if attempting:
		#For clarity
		print_debug(targeter.name +" from team "+str(targeter.get_meta("Team")) \
		+ " is attempting to hit " + attemptor.name + " from team "+ str(attemptor.get_meta("Team")))
		
		if attemptor.get_meta("Team") != targeter.get_meta("Team"):
			hitlist.append(attemptor)
			targets_to_get -= 1
			attempting = false

func _hit_targets():
	print(hitlist)
	for minion in hitlist:
		var dmg = randi_range(moveEffect.dmg.x,moveEffect.dmg.y)
		print(dmg)
		minion._get_affected(dmg)
	hitlist.clear()
	emit_signal("move_complete")

func _select_hitlist(minion : Minion,team1 : Array[Minion],team2 : Array[Minion]):
	if team1.find(minion) != -1:
		if len(team2) <= targets_to_get:
			hitlist.append_array(team2)
		else:
			for i in range(0,targets_to_get):
				var idx = randi_range(0,len(team2))
				if hitlist.find(team2[idx]) != -1 : hitlist.append(team2[idx])
		_hit_targets()
	if team2.find(minion) != -1:
		if len(team1) <= targets_to_get:
			hitlist.append_array(team1)
		else:
			for i in range(0,targets_to_get):
				var idx = randi_range(0,len(team1)-1)
				hitlist.append(team1[idx])
		_hit_targets()
