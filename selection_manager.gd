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
	hitlist.clear()
	moveEffect = effect
	targeter = minion
	target = effect.target
	targetChooser = effect.targetSelector
	targetNo = effect.targetNo
	selectMode = true
	targets_to_get = targetNo
	match effect.targetSelector:
		1:#Random
			_select_hitlist(minion,team1,team2,effect.target)
		2:#Self
			hitlist.append(minion)
			_hit_targets()
		3:#All
			_select_hitlist(minion,team1,team2,effect.target)
		0:#Player selects
			emit_signal("selectActivated",minion,target,targeter.get_meta("Team"))

func _process(delta: float) -> void:
	if attempting:
		hitlist.append(attemptor)
		targets_to_get -= 1
		attempting = false

func _hit_targets():
	for minion in hitlist:
		var dmg = randi_range(moveEffect.dmg.x,moveEffect.dmg.y)
		print_debug(dmg)
		minion._get_affected(dmg)
	emit_signal("move_complete")

func _select_hitlist(minion : Minion,team1 : Array[Minion],team2 : Array[Minion],teamToSelect : int):
	if team1.find(minion) != -1:
		match teamToSelect:
			0:#Enemy team
				if len(team2) <= targets_to_get or moveEffect.targetSelector == 3: 
					hitlist.append_array(team2)
				else:
					var i = 0
					var temp : Array[int] = []
					while i < targets_to_get:
						randomize()
						var idx = randi_range(0,len(team2)-1)
						if temp.find(idx) == -1:
							hitlist.append(team2[idx])
							temp.append(idx)
							i += 1
						else: continue
				_hit_targets()
			1:#Own team
				if len(team1) <= targets_to_get or moveEffect.targetSelector == 3: hitlist.append_array(team1)
				
				else:
					var i = 0
					var temp : Array[int] = []
					while i < targets_to_get:
						randomize()
						var idx = randi_range(0,len(team1)-1)
						if temp.find(idx) == -1:
							hitlist.append(team1[idx])
							temp.append(idx)
							i += 1
						else: continue
				_hit_targets()

	if team2.find(minion) != -1:
		match teamToSelect:
			0:
				if len(team1) <= targets_to_get or moveEffect.targetSelector == 3: hitlist.append_array(team1)
				
				else:
					for i in range(0,targets_to_get):
						var idx = randi_range(0,len(team1)-1)
						hitlist.append(team1[idx])
				_hit_targets()
			
			1:
				if len(team2) <= targets_to_get or moveEffect.targetSelector == 3: hitlist.append_array(team2)
				
				else:
					var i = 0
					var temp : Array[int] = []
					while i < targets_to_get:
						randomize()
						var idx = randi_range(0,len(team2)-1)
						if temp.find(idx) == -1:
							hitlist.append(team2[idx])
							temp.append(idx)
							i += 1
						else: continue
				_hit_targets()

