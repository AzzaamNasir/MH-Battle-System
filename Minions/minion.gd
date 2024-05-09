extends Node2D

@export var minionData : MinionData
@export var SelectMenu : Control

func _ready() -> void:
	load(minionData.resource_path)
	$Sprite.texture = minionData.sprite

