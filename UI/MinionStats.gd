extends Control

@onready var health_bar: TextureProgressBar = %HealthBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	owner.connect("affected",_on_affected)
	health_bar.max_value = owner.minionData.health
	health_bar.value = health_bar.max_value


func _on_affected(type,value):
	if type == "damage":
		health_bar.value = owner.health
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
