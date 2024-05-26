@tool
class_name MoveEffects
## The base class for the effects which the move will have.
## Choose for attacks like claw, which only hit one enemy selected by you
## All subsets of this(Such as sin_dmg_en.gd) follow the naming scheme below:
## "sin"=single,"tri"=triple,"all","self","dmg"=damaging,"heal"=healing,"en"=enemy,"al"=ally
## add words "range" if dmg/heal is variable, "rand" if targets chosen randomly
## "ot" if it is done overtime or is a temporary status effect
extends Resource

enum TargetSelector{
	PLAYER,
	RANDOM,
	SELF,
	ALL,
}
enum Attributes{
	NONE,
	ATTACK,
	HEALTH,
	SPEED,
	ENERGY,
	HEALING,
}
enum Effect{
	DAMAGESORHEALS,
	BUFFSORDEBUFFS,
}

## Click this if the correct field is not appearing.
## Don't worry if you don't see anything happening
@export var notify : bool = false :
	set(value):
		if value == true:
			notify = false
			notify_property_list_changed()

## Choose damage for healing as well.
## Similarly, choose buffs for debuffs as well
var effect : Effect
var accuracy : int ## How accurate is the attack?
var target_no : int ## Number of targets?
var target_selector : int ## Who will select the targets?
var targeted_team : int ## Which team to target? 0=target enemies,1= target allies
var buff_percent : int ## How much to buff?(In percent)
var buff_attribute : Attributes ## What attribute should be buffed?
## Does it do damage overtime?
## True for status effects
var do_overtime : bool
var turn_duration : int ## For how many turns does the effect last?
## How much damage does it do?
## If there's a range, this is minimum dmg
var damage : int
var max_damage : int = 0 ## This is maximum damage for ranged attacks, 0 for normal attacks
## Will this be applied to the same minions previously selected
## or should we select again?
@export var new_selection : bool
## Manages what properties to show in the inspector
## for different types of moves
func _get_property_list():
	if Engine.is_editor_hint():
		var properties = []
		
		if (
			self is SingleEnemyDamage\
			or self is SingleEnemyDamageOvertime\
			or self is TripleEnemyDamage\
			or self is TripleEnemyDamageRandom\
			or self is SingleEnemyDamageRange
			or self is SelfHeal\
			or self is AllEnemyDamage
		):
			properties.append({
			"name" = "damage",
			"type" = TYPE_INT,
			})
		
		if (
			self is SingleEnemyDamageRange
		):
			properties.append({
				"name" = "max_damage",
				"type" = TYPE_INT,
			})
			
			
		if (
			self is SingleEnemyDebuff\
			or self is SelfBuff
		):
				properties.append({
				"name" : "buff_attribute",
				"type" : TYPE_INT,
				"hint" : PROPERTY_HINT_ENUM,
				"hint_string": Attributes
			})
			
		if (
			self is SingleEnemyDebuff\
			or self is SelfBuff
		):
				properties.append({
				"name" = "buff_percent",
				"type" = TYPE_INT,
			})
			
		if (
			self is SingleEnemyDebuff\
			or self is SelfBuff
		):
				properties.append({
				"name" = "turn_duration",
				"type" = TYPE_INT,
			})
		
		if(
			self is SingleEnemyDamageOvertime\
		):
				properties.append({
				"name" = "turn_duration",
				"type" = TYPE_INT
				}) 
		
		return properties
