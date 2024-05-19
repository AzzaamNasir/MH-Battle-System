extends Node2D
class_name Minion 

@export var minionData : MinionData
@export var SelectMenu : MoveMenu

signal minion_died(minion)
signal select_attempt(minion)
signal SelectionTime(minion ,move : MoveData)
signal affected(stat : String,amount : int)

@onready var sprite: Sprite2D = $Sprite
@onready var click_detector: Button = %ClickDetector
var moveUsed : Callable = Callable(self, "_calc_move_stats")

var health : float:
	set(value):
		health = clamp(value,0,minionData.health)
var atk : int
var speed : int
var healing : int
var energy : int:
	set(value):
		energy = clamp(energy,0,minionData.energy)

func _ready() -> void:
	health = minionData.health
	atk= minionData.atk	
	speed= minionData.speed
	healing= minionData.healing
	energy= minionData.energy
	get_parent().get_parent().get_parent().move_processed.connect(move_processed)
	click_detector.pressed.connect(Callable(self,"_on_click").bind(click_detector))
	click_detector.size = sprite.get_rect().size
	$Sprite.texture = minionData.sprite
	SelectMenu.moveUsed.connect(moveUsed)
	SelectMenu.energy_bar.max_value = minionData.energy
	SelectMenu.energy_bar.value = minionData.energy
	SelectMenu.energy_label.text = str(minionData.energy) + "/" + str(minionData.energy)

func _on_click(button : Button):
	if SelectionManager.selectMode:
		emit_signal("select_attempt",self)
		button.hide()

func _calc_move_stats(move : MoveData):
	energy -= move.energy 
	SelectMenu.energy_label.text = str(energy) + "/" + str(minionData.energy)
	
	emit_signal("SelectionTime",self,move)#relay final dmg to FightController

func _get_affected(val : int):
	health -= val
	if health <= 0:
		emit_signal("minion_died",self)
		queue_free()
	emit_signal("affected","damage",val)
	
func move_processed():
	click_detector.hide()
