extends Node

signal selectActivated(minion,targets,targeter)

var targeter
var selectMode : bool = false
var target : int
var targetChooser : int
var targetNo : int
var targets_to_get : int:
	set(new_val):
		targets_to_get = new_val
		if new_val == 0:
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

func activateSelectMode(minion, effect : MoveEffects):
	moveEffect = effect
	targeter = minion
	target = effect.target
	targetChooser = effect.targetSelector
	targetNo = effect.targetNo
	selectMode = true
	targets_to_get = targetNo
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
	targeter.get("SelectMenu").show()
	for minion in hitlist:
		var dmg = randi_range(moveEffect.dmg.x,moveEffect.dmg.y)
		print("Damege: " + str(dmg))
		minion._get_affected(dmg)
	hitlist.clear()