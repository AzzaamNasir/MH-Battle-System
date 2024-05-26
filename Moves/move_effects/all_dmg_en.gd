@tool
class_name AllEnemyDamage
## Affects all minions in enemy team
extends MoveEffects

func _init() -> void:
	accuracy = 100
	effect = Effect.DAMAGESORHEALS
	target_no = 1 # Does'nt matter
	targeted_team = 0
	target_selector = TargetSelector.ALL
	buff_percent = 0
	buff_attribute = Attributes.NONE
	do_overtime = false
	turn_duration = 0
