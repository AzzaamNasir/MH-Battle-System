@tool
extends Resource

class_name MoveData

@export var name : String
@export var sprite : Texture2D
##What class does the attack belong to? (Fire, electric etc)
@export var element : ELEMENT
##The energy it takes
@export var energy : int
##cooldown(if any)
@export var cooldown : int = 0


enum ELEMENT {
	Normal,
	Flying,
	Plant,
	Water,
	Earth,
	Ice,
	Fire,
	Electric,
	Robot,
	Dino,
	Undead,
	Demonic,
	Holy,
	Titan
}

##Add whatever the attack does in this array
@export var effects : Array[MoveEffects]
