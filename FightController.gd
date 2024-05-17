extends Node2D

signal move_processed
var team_1 : Array[Minion]
var team_2 : Array[Minion]
var turnOrder : Array[Minion]
var selection : Callable = Callable(self,"_select")
var minionList : Array[Node2D]
var turn : int = -1
# Called when the node enters the scene tree for the first time.
func _ready():
	$MinionSelector.connect("play_pressed",_start)
	SelectionManager.selectActivated.connect(applyFilter)
	SelectionManager.move_complete.connect(_on_button_pressed)

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
		turnOrder.append(min) #Store the UNIQUE reference to an array
		team_1.append(min)
		minionList.append(min)
		min.minion_died.connect(_on_death)
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
		team_2.append(min)
		turnOrder.append(min)
		minionList.append(min)
		min.set_meta("Team",2)
		min.minion_died.connect(_on_death)
		min.SelectionTime.connect(selection)
		min.select_attempt.connect(_attempt)
		await min
	
	#Now we determine the turn order using bubble sort
	for i in len(turnOrder)-1:
		for j in len(turnOrder)-1-i:
			if turnOrder[j].minionData.speed > turnOrder[j+1].minionData.speed:
				var temp = turnOrder[j]
				turnOrder[j] = turnOrder[j+1]
				turnOrder[j+1] = temp
	
	turnOrder.reverse()#This will mak turn order go from highest speed to lowest speed
	game_start()

func _select(minion : Node2D, move : MoveData):
	for effect : MoveEffects in  move.effects:
		if effect.override_properties:
			SelectionManager.activateSelectMode(minion,effect,team_1,team_2)

func _attempt(minion : Node2D):
	SelectionManager.attemptor = minion
	SelectionManager.attempting = 1

func applyFilter(minion : Minion,target,targeterTeam):
	var targetType : int
	for subject in minionList.duplicate():
		match targetType:
			0:
				if subject.get_meta("Team") != targeterTeam: 
					subject.click_detector.show()
			1:
				if subject.get_meta("Team") == targeterTeam: subject.click_detector.show()
			_:
				print("Not implemented yet")

#Turn order stores the characters in the order in which they play
#game_start just allows the next character in turnOrder to play
#_on_death executes whenever a character dies 
func _on_button_pressed() -> void:
	emit_signal("move_processed")
	game_start()

func game_start():
	turn = 0 if turn >= len(turnOrder)-1 else turn+1
	turnOrder[turn].SelectMenu.show()

func _on_death(minion):
	turn -= 1
	turnOrder.erase(minion)
	team_1.erase(minion)
	team_2.erase(minion)
	minionList.erase(minion)
