extends Node2D

@export var minionData : MinionData
@export var SelectMenu : Control

signal select_attempt(minion)
signal SelectionTime(minion ,move : MoveData)

@onready var sprite: Sprite2D = $Sprite
@onready var click_detector: Button = %ClickDetector

var moveUsed : Callable = Callable(self, "_calc_move_stats")

func _ready() -> void:
	click_detector.pressed.connect(Callable(self,"_on_click").bind(click_detector))
	click_detector.size = sprite.get_rect().size
	$Sprite.texture = minionData.sprite
	SelectMenu.moveUsed.connect(moveUsed)

func _on_click(button : Button):
	if SelectionManager.selectMode:
		emit_signal("select_attempt",self)

func _calc_move_stats(move : MoveData):
	print_debug("yep")
	emit_signal("SelectionTime",self,move)#relay final dmg to FightController

func _get_affected(dmg : int):
	minionData.health -= dmg
	print(minionData.health)
	if minionData.health == 0:
		queue_free()
