@tool
class_name TripleEnemyDamageRandom
## Hits three enemies chosen randomly
extends MoveEffects

func _init() -> void:
	accuracy = 100
	effect = Effect.DAMAGESORHEALS
	target_no = 3
	targeted_team = 0
	target_selector = TargetSelector.RANDOM
	debuff_percent = 0
	debuff_attribute = Attributes.NONE
	do_overtime = false
	turn_duration = 0
