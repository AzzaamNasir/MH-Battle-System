extends Node2D

var turnOrder : Array[MinionData]
# Called when the node enters the scene tree for the first time.
func _ready():
	$MinionSelector.connect("play_pressed",_start)

func _start(team1 : Array[MinionData],team2 : Array[MinionData]):
	var k = 1
	for minion in team1:
		var min : Node2D = load(minion.scene).instantiate()
		min.add_to_group("Team 1")
		min.get_node("Sprite").flip_h = true
		get_node("L_Minions/L" + str(k)).add_child(min)
		k+=1
		min.minionData = min.minionData.duplicate()
		turnOrder.append(min.minionData)
		await min
		minion.speed += 100
	k=1
	for minion in team2:
		var min : Node2D = load(minion.scene).instantiate()
		min.add_to_group("Team 2")
		get_node("R_Minions/R" + str(k)).add_child(min)
		k+=1
		min.minionData = min.minionData.duplicate()
		turnOrder.append(min.minionData)
		await min
	
	
	for i in len(turnOrder)-1:
		for j in len(turnOrder)-1-i:
			if turnOrder[j].speed > turnOrder[j+1].speed:
				var temp = turnOrder[j]
				turnOrder[j] = turnOrder[j+1]
				turnOrder[j+1] = temp
			else:
				break
	
	turnOrder.reverse()
	for minion in turnOrder:
		print(minion.name + " " + str(minion.speed) + str(minion.get_instance_id()))
	
