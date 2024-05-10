extends Node2D

@export var minionData : MinionData
@export var SelectMenu : Control

var moveUsed : Callable = Callable(self, "_calc_move_stats")

func _ready() -> void:
	$Sprite.texture = minionData.sprite
	SelectMenu.moveUsed.connect(moveUsed)

func _calc_move_stats(move):
	pass#We need to calculate and relay the final dmg to the fight controller
