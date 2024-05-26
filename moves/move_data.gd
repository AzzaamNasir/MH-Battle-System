extends Resource
class_name MoveData
## Stores all the data about the moves

@export var name : String
@export var sprite : Texture2D
## What class does the attack belong to? (Fire, electric etc)
@export var element : Element
## The energy it takes
@export var energy : int
## cooldown(if any)
@export var cooldown := 0

## Add whatever the attack does in this array
@export var effects : Array[MoveEffects]

enum Element {
	NORMAL,
	FLYING,
	PLANT,
	WATER,
	EARTH,
	ICE,
	FIRE,
	ELECTRIC,
	ROBOT,
	DINO,
	UNDEAD,
	DEMONIC,
	HOLY,
	TITAN,
}
