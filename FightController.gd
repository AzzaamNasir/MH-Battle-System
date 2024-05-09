extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$MinionSelector.connect("play_pressed",_start)


func _start(team1 : Array[MinionData],team2 : Array[MinionData]):
	var i = 1
	for minion in team1:
		var min : Node2D = minion.scene.instantiate()
		min.get_node("Sprite").flip_h = true
		get_node("L_Minions/L" + str(i)).add_child(min)
		i+=1
	i=1
	for minion in team2:
		var min : Sprite2D = load(minion["Path"]).instantiate()
		get_node("R_Minions/R" + str(i)).add_child(min)
		i+=1
