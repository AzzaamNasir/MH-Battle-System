@tool
class_name DoubleEnemyDamage
extends MoveEffects

func _init() -> void:
	accuracy = 100
	effect = Effect.DAMAGESORHEALS
	target_no = 2
	targeted_team = 0
	target_selector = TargetSelector.PLAYER
	buff_percent = 0
	buff_attribute = Attributes.NONE
	do_overtime = false
	turn_duration = 0
