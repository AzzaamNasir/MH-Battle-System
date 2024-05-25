@tool
class_name SelfBuff
# Heals yourself
extends MoveEffects

func _init() -> void:
	accuracy = 100
	effect = Effect.BUFFSORDEBUFFS
	target_no = 1
	targeted_team = 1
	target_selector = TargetSelector.SELF
	damage = 0
	do_overtime = false
	turn_duration = 0
	new_selection = true
