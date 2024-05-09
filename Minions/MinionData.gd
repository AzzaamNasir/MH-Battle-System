extends Resource

class_name MinionData


@export var name : String
@export var sprite : Texture2D
@export var scene : PackedScene

@export var health : int
@export var energy : int
@export var atk : int
@export var healing : int
@export var speed : int

@export var type1 : MinionType = 0
@export var type2 : MinionType = 0


enum MinionType {
	None,
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

@export var MinionMoves : Array[MoveData]
