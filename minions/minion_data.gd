extends Resource

class_name MinionData


@export var name : String
@export var sprite : Texture2D
##Drag the .tscn file of the minion here
@export_file("*.tscn") var scene : String

@export var health : int
@export var energy : int
@export var attack : int
@export var healing : int
@export var speed : int

@export var type1 : MinionType = MinionType.NONE
@export var type2 : MinionType = MinionType.NONE


enum MinionType {
	NONE,
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
	TITAN
}

##Instert the .tres files of the moves htis minion has here
@export var moves : Array[MoveData]
