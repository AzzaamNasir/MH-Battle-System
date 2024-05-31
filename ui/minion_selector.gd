extends CanvasLayer

#Will wmit when we press play
signal start_game(team1 : Array[MinionData],team2 : Array[MinionData])

@onready var minions1 : ItemList = %MinionList1
@onready var minions2 : ItemList = %MinionList2

@onready var play : Button = %Play

@export var minions : ResourceGroup
var minion_list : Array[MinionData]


func _ready():
	minion_list = minions.load_all_into()
	play.connect("pressed",_on_play_pressed)
	for minion in minion_list:
		minions1.add_item(minion.name,minion.sprite)
		minions2.add_item(minion.name,minion.sprite)


func _on_play_pressed():
	var team1 : Array[MinionData] = []
	for i in minions1.get_selected_items():
		team1.append(minion_list[i])

	var team2 : Array[MinionData] = []
	for i in minions2.get_selected_items():
		team2.append(minion_list[i])

	# Emit that play has been pressed,Fight controller will take it from here
	emit_signal("start_game",team1,team2)
	hide()

