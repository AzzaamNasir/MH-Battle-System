@tool
extends Resource

class_name MoveEffects

func _get_property_list():
	var properties = []
	
	if type == MOVETYPE.DamagesOrHeals:
		properties.append({
		"name" = "dmg",
		"type" = TYPE_VECTOR2,
		})
		
	if type == MOVETYPE.BuffsOrDebuffs:
		properties.append({
		"name" = "buffAttribute",
		"type" = TYPE_INT,
		"hint" = PROPERTY_HINT_ENUM,
		"hint_string" = ATTRIBUTES
		})
		properties.append({
		"name" = "buffPercent",
		"type" = TYPE_INT,
		})
		
	if doOvertime:
		properties.append({
		"name" = "turnDuration",
		"type" = TYPE_INT
		})
	
	return properties


##accuracy of the attack(in percentage)
@export var accuracy : int = 100
##What does the move do?
@export var type : MOVETYPE = MOVETYPE.DamagesOrHeals:
	set(value):
		type = value
		notify_property_list_changed()
##no of enemies/allies it targets
@export var targetNo : int = 1 
##Are the targets are selected by player or at random. 0=Player 1=Random 2=All
@export_enum("Player","Random","Self","All") var targetSelector : int= 0    
##Does it target enemies or allies. 0=Enemy,1=Ally,2=Self
@export_enum("Enemy","Ally") var target : int = 0
##How much does it buff(In percentage) Use negative if its a debuff. Leave at zero for effects like frozen
var buffPercent = 0
##What does it buff?
var buffAttribute : ATTRIBUTES
##Does it do anything over time?
@export var doOvertime : bool:
	set(value):
		doOvertime = value
		notify_property_list_changed()
#How many turns will it last?
var turnDuration : int = 0
var dmg : Vector2 = Vector2(0,0)

@export var override_properties : bool

enum ATTRIBUTES{
	Attack,
	Health,
	Speed,
	Energy,
	Healing,
	Frozen,
	Stunned,
	Exhausted
}

enum MOVETYPE{
	DamagesOrHeals,
	BuffsOrDebuffs
}
