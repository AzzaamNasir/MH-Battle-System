extends Node

var targeter
var selectMode : bool = false
var target : int
var targetChooser : int
var targetNo : int
var targets_to_get : int:
	set(new_val):
		targets_to_get = new_val
		if new_val == 0:
			print("Damage time")
var attempting
var attemptor : Node2D = null

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

func activateSelectMode(minion, effect : MoveEffects):
	targeter = minion
	target = effect.target
	targetChooser = effect.targetSelector
	targetNo = effect.targetNo
	selectMode = true
	targets_to_get = targetNo

func _process(delta: float) -> void:
	if attempting:
		if attemptor.get_meta("Team") != targeter.get_meta("Team"):
			targets_to_get -= 1
