extends Node2D
class_name Minion
## The main minion class, which contains and manages all the stats of the minions

signal minion_died(minion : Minion)
signal minion_selected(minion : Minion)
signal minion_move_selected(minion : Minion, move : MoveData)
signal minion_stat_changed(stat : String)

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

var passive_list := [] # List of all current status effects
var active_list := [] # List of all current overtime damage

@onready var move_menu : MoveMenu = %MoveMenu
@onready var minion_stats: MinionStats = %MinionStats
@onready var sprite: Sprite2D = $Sprite
@onready var click_detector: Button = %ClickDetector

func move_compete():
	move_menu.energy_bar.value = energy
	move_menu.energy_label.text = str(energy) + "/" + str(minion_data.energy) 

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
	minion_stats.health_bar.value = health
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

func update_overtime_effects():
	_update_active_effects()
	_update_passive_effects()

func _update_passive_effects():
	for effect in passive_list:
		effect["turns"] -= 1
		if effect["turns"] == 0:
			set(effect["property"],get(effect["property"]) + effect["value"])
			passive_list.erase(effect)

func _update_active_effects():
	for effect : Array in active_list:
		take_damage(effect[0].damage if effect[0].max_damage == 0\
						else randi_range(effect[0].damage,effect[0].max_damage))
		effect[1] -= 1
		if effect[1] == 0:
			active_list.erase(effect)

func add_active_effect(effect : MoveEffects):
	active_list.append([effect,effect.turn_duration])

func add_passive_effect(effect : MoveEffects):
	var property_string = StringName((effect.Attributes.keys()[effect.debuff_attribute]).to_lower())
	var value
	
	match property_string:
		"attack":
			value = effect.debuff_percent * 0.01 * attack
		"speed":
			value = effect.debuff_percent * 0.01 * speed
		"energy":
			value = effect.debuff_percent * 0.01 * minion_data.energy
			move_menu.energy_label.text = str(energy) + "/" + str(minion_data.energy)
			move_menu.energy_bar.value = energy
		"healing":
			value = effect.debuff_percent * 0.01 * healing
		
	if effect.turn_duration != 0:
		var to_be_added = {
		"effect" = effect,
		"value" = value,
		"property" = property_string,
		"turns" = effect.turn_duration
		}
		passive_list.append(to_be_added)
	
	set(property_string,int(get(property_string) - value))
	minion_stat_changed.emit(property_string)

func show_click_detector():
	click_detector.show()
