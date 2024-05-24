extends Node2D
class_name Minion
## The main minion class, which contains and manages all the stats of the minions

signal minion_died(minion : Minion)
signal minion_selected(minion : Minion)
signal minion_move_selected(minion : Minion, move : MoveData)
signal minion_affected
signal minion_stat_effected()

@export var minion_data : MinionData

var health : int:
	set(value): # Whenever health is set, limit it to the range 0 and max health
		health = clampi(value,0,minion_data.health)
var energy : int: 
	set(value): # Whenever energy is set, limit it to the range 0 and max energy
		energy = clampi(value,0,minion_data.energy)
var atk : int
var speed : int
var healing : int

## List of all the effects(Status and overtime damage) the minion currently has
var effect_list : Array[TimedEffect]

@onready var move_menu : MoveMenu = %MoveMenu
@onready var minion_stats: MinionStats = %MinionStats
@onready var sprite: Sprite2D = $Sprite
@onready var click_detector: Button = %ClickDetector


func _ready() -> void:
	#region Initializing Stats
	# Initializing minion stats
	%Sprite.texture = minion_data.sprite
	health = minion_data.health
	atk = minion_data.atk
	speed = minion_data.speed
	healing = minion_data.healing
	energy = minion_data.energy
	#endregion

	click_detector.pressed.connect(Callable(self,"_on_minion_selected").bind(click_detector))


func take_damage(damage : int):
	print_debug(damage)
	self.health -= damage
	emit_signal("minion_affected")
	if health <= 0:
		emit_signal("minion_died",self)
		queue_free()

func _on_minion_selected(button : Button):
	emit_signal("minion_selected",self)
	button.hide()

func move_selected(move : MoveData):
	if move.energy >= energy:
		print_rich("[color=red][b]YOU DON'T HAVE ENOUGH ENERGY FOR THIS MOVE![/b][/color]")
		move_menu.show()
	else:
		energy = energy - move.energy
		move_menu.energy_label.text = str(energy) + "/" + str(minion_data.energy)
		emit_signal("minion_move_selected",self,move)#relay final dmg to FightController


func _add_overtime_effect(move : MoveEffects):
	effect_list.append(move)
	effect_list.append(move.turnDuration)

func move_completed():
	click_detector.hide()

func _apply_overtime_effects():
	for effect in effect_list:
		match effect.effect:
			0: # DamagesOrHeals
				health -= effect.value
			1: # Buffs/Debuffs
				pass # Buff/Debuff data goes here

func show_click_detector():
	click_detector.show()

class TimedEffect:
	var minion : Minion
	var effect :  int # DamagesOrHeals = 0, BuffsOrDebuffs = 1
	var duration : int
	var value : int
	
	func _init(minion : Minion, effect : int, duration : int, value : int) -> void:
		self.minion = minion
		self.effect = effect
		self.duration = duration
		self.value = value
		self.minion.effect_list.append(self)

