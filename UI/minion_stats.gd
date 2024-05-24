extends Control
class_name MinionStats
@onready var health_bar: TextureProgressBar = %HealthBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	owner.minion_affected.connect(_on_affected)
	health_bar.max_value = owner.minion_data.health
	health_bar.value = health_bar.max_value

func _on_affected():
	health_bar.value = owner.health
