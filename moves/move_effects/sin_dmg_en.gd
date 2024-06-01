@tool
class_name SingleEnemyDamage
## Hits single enemy chosen by the player
extends MoveEffects

func _init() -> void:
	accuracy = 100
	effect = Effect.DAMAGESORHEALS
	target_no = 1
	targeted_team = 0
	target_selector = TargetSelector.PLAYER
	debuff_percent = 0
	debuff_attribute = Attributes.NONE
	do_overtime = false
	turn_duration = 0
