extends Node2D

var turnOrder : Array[MinionData]
# Called when the node enters the scene tree for the first time.
func _ready():
	$MinionSelector.connect("play_pressed",_start)

#Will be executed when play is pressed
func _start(team1 : Array[MinionData],team2 : Array[MinionData]):
	var k = 1
	
	for minion in team1:
		var min : Node2D = load(minion.scene).instantiate() #Load all selected minions
		min.add_to_group("Team 1")
		min.get_node("Sprite").flip_h = true #Set correct orientation
		get_node("L_Minions/L" + str(k)).add_child(min) #INsert the loaded minion to the scene
		k+=1
		min.minionData = min.minionData.duplicate() #Duplicate the minion data so it can be edited individually
		turnOrder.append(min.minionData) #Store the UNIQUE reference to an array which we will use to determin the turn order
		await min #Wait for the minion to load
		
	k=1
	for minion in team2:
		var min : Node2D = load(minion.scene).instantiate()
		min.add_to_group("Team 2")
		get_node("R_Minions/R" + str(k)).add_child(min)
		k+=1
		min.minionData = min.minionData.duplicate()
		turnOrder.append(min.minionData)
		await min
	
	#Now we determine the turn order using bubble sort
	for i in len(turnOrder)-1:
		for j in len(turnOrder)-1-i:
			if turnOrder[j].speed > turnOrder[j+1].speed:
				var temp = turnOrder[j]
				turnOrder[j] = turnOrder[j+1]
				turnOrder[j+1] = temp
			else:
				break
	
	turnOrder.reverse()#This will mak turn order go from highest speed to lowest speed
	
