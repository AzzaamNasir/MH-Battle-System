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
var attack : int
var speed : int
var healing : int

## List of all the effects(Status and overtime damage) the minion currently has
var passive_list : Array[Dictionary]

@onready var move_menu : MoveMenu = %MoveMenu
@onready var minion_stats: MinionStats = %MinionStats
@onready var sprite: Sprite2D = $Sprite
@onready var click_detector: Button = %ClickDetector


func _ready() -> void:
	#region Initializing Stats
	# Initializing minion stats
	%Sprite.texture = minion_data.sprite
	health = minion_data.health
	attack = minion_data.attack
	speed = minion_data.speed
	healing = minion_data.healing
	energy = minion_data.energy
	#endregion

	click_detector.pressed.connect(Callable(self,"_on_minion_selected").bind(click_detector))


func take_damage(damage : int):
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
		move_menu.show()
	else:
		energy = energy - move.energy
		move_menu.energy_label.text = str(energy) + "/" + str(minion_data.energy)
		emit_signal("minion_move_selected",self,move)#relay final dmg to FightController


func _add_overtime_effect(move : MoveEffects):
	passive_list.append(move)
	passive_list.append(move.turnDuration)

func move_completed():
	click_detector.hide()

func update_overtime_effects():
	_update_active_effects()
	_update_passive_effects()

func _update_passive_effects():
	for effect in passive_list:
		effect["value"] -= 1
		if effect["value"] == 0: passive_list.erase(effect)

func _update_active_effects():
	pass

func add_passive_effect(effect : MoveEffects):
	var property_string = StringName((effect.Attributes.keys()[effect.buff_attribute]).to_lower())
	if effect.turn_duration != 0:
		passive_list.append({
			"attribute" : property_string,
			"duration_left" : effect.turn_duratison,
			"value" : effect.buff_percent
		})
	set(property_string,get(property_string) - ((effect.buff_percent * 0.01) * get(property_string)))

func show_click_detector():
	click_detector.show()

