@tool
class_name AllAllyHeal
extends MoveEffects

func _init() -> void:
	accuracy = 100
	effect = Effect.DAMAGESORHEALS
	target_no = 1 # Doesn't matter
	targeted_team = 1
	target_selector = TargetSelector.ALL
	debuff_percent = 0
	debuff_attribute = Attributes.NONE
	do_overtime = false
	turn_duration = 0
