extends CanvasLayer

#Will wmit when we press play
signal play_pressed(team1 : Array[MinionData],team2 : Array[MinionData])

@onready var Minions1 : ItemList = %MinionList1
@onready var Minions2 : ItemList = %MinionList2

@onready var play : Button = %Play

@export var minions : ResourceGroup
var minionArr : Array[MinionData]


func _ready():
	minionArr = minions.load_all_into()
	play.connect("pressed",_on_play_pressed)
	for minion in minionArr:
		Minions1.add_item(minion.name,minion.sprite)
		Minions2.add_item(minion.name,minion.sprite)


func _on_play_pressed():
	#Will contain all minions of team 1
	var l_team : Array[MinionData]
	
	for i in Minions1.get_selected_items():#Insert all the selected minions of team 1 into an array
		l_team.append(minionArr[i])
	
	var r_team : Array[MinionData]
	
	for i in Minions2.get_selected_items():
		r_team.append(minionArr[i])
	
	#Emit that play has been pressed,Fight controller will take it from here
	emit_signal("play_pressed",l_team,r_team)
	hide()
	
