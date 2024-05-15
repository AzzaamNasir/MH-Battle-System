extends Node2D

var turnOrder : Array[MinionData]
var selection : Callable = Callable(self,"_select")
var minionList : Array[Node2D]
# Called when the node enters the scene tree for the first time.
func _ready():
	$MinionSelector.connect("play_pressed",_start)
	SelectionManager.selectActivated.connect(applyFilter)

#Will be executed when play is pressed
func _start(team1 : Array[MinionData],team2 : Array[MinionData]):
	var k = 1
	
	for minion in team1:
		var min : Node2D = load(minion.scene).instantiate() #Load all selected minions
		min.add_to_group("Team 1")
		min.get_node("Sprite").flip_h = true #Set correct orientation
		get_node("L_Minions/L" + str(k)).add_child(min) #INsert the loaded minion to the scene
		k+=1
		min.minionData = min.minionData.duplicate() #For unique editing
		min.set_meta("Team",1)
		turnOrder.append(min.minionData) #Store the UNIQUE reference to an array
		minionList.append(min)
		min.SelectionTime.connect(selection)
		min.select_attempt.connect(_attempt)
		await min #Wait for the minion to load
		
	k=1
	for minion in team2:
		var min : Node2D = load(minion.scene).instantiate()
		min.add_to_group("Team 2")
		get_node("R_Minions/R" + str(k)).add_child(min)
		k+=1
		min.minionData = min.minionData.duplicate()
		turnOrder.append(min.minionData)
		minionList.append(min)
		min.set_meta("Team",2)
		min.SelectionTime.connect(selection)
		min.select_attempt.connect(_attempt)
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

func _select(minion : Node2D, move : MoveData):
	for effect : MoveEffects in  move.effects:
		if effect.override_properties:
			SelectionManager.activateSelectMode(minion,effect)

func _attempt(minion : Node2D):
	SelectionManager.attemptor = minion
	SelectionManager.attempting = 1

func applyFilter(minion : Minion,target,targeterTeam):
	var targetType : int
	for subject in minionList.duplicate():
		match targetType:
			0:
				if subject.get_meta("Team") != targeterTeam: subject.click_detector.show()
			1:
				if subject.get_meta("Team") == targeterTeam: subject.click_detector.show()
			_:
				print("Not implemented yet")

