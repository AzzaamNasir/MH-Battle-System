@tool
extends Resource

class_name MoveData

@export_group("Basic Info")
@export var name : String
@export var sprite : Texture2D
##What class does the attack belong to? (Fire, electric etc)
@export_group("Move properties")
@export var element : ELEMENT
##The energy it takes
@export var energy : int
##cooldown(if any)
@export var cooldown : int = 0

@export_group("Effects")
##Add whatever the attack does in this array
@export var effects : Array[MoveEffects]

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
