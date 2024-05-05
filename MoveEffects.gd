@tool
extends Resource

class_name MoveEffects

func _get_property_list():
	var properties = []
	
	if type == MOVETYPE.Damages or type == MOVETYPE.Heals:
		properties.append({
		"name" = "dmgMin",
		"type" = TYPE_INT,
		})
		properties.append({
		"name" = "dmgMax",
		"type" = TYPE_INT,
		})
		
	if type == MOVETYPE.Buffs or type == MOVETYPE.Debuffs:
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
		
	return properties


##accuracy of the attack(in percentage)
@export var accuracy : int = 100
##Make it negative if its a healing move
var dmgMin : int = 0
##Make it negative if its a healing move
var dmgMax : int = 0
##What does the move do?
@export var type : MOVETYPE = MOVETYPE.Damages:
	set(value):
		type = value
		notify_property_list_changed()
##no of enemies/allies it targets
@export var targetNo : int = 1 
##Are the targets are selected by player or at random. 0=Player 1=Random 2=All
@export_enum("Player","Random","All") var targetSelector : int= 0    
##Does it target enemies or allies. 0=Enemy,1=Ally,2=Self
@export_enum("Enemy","Ally","Self") var target : int = 0
##How much does it buff(In percentage) Use negative if its a debuff
var buffPercent = 0
##What does it buff?
var buffAttribute : ATTRIBUTES


enum ATTRIBUTES{
	Attack,
	Health,
	Speed,
	Energy,
	Healing
}

enum MOVETYPE{
	Damages,
	Heals,
	Buffs,
	Debuffs
}
