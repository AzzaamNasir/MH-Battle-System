@tool
class_name SingleEnemyDebuff
# Heals yourself
extends MoveEffects

func _init() -> void:
	accuracy = 100
	effect = Effect.BUFFSORDEBUFFS
	target_no = 1
	targeted_team = 0
	target_selector = TargetSelector.PLAYER
	damage = 0
	do_overtime = true
	new_selection = false
