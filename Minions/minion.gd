extends Node2D

@export var minionData : MinionData
@export var SelectMenu : Control

func _ready() -> void:
	$Sprite.texture = minionData.sprite
