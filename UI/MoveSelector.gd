extends Control

var minMoveList : Array[MoveData]
#region ButtonReferencer
@onready var button1 : TextureButton = %Move1  
@onready var button2 : TextureButton = %Move2
@onready var button3 : TextureButton = %Move3
@onready var button4 : TextureButton = %Move4
@onready var button5 : TextureButton = %Move5
@onready var button6 : TextureButton = %Move6
#endregion

signal moveUsed(move : MoveData)

var buttonPressed : Callable = Callable(self,"_pressed")
var setProperties : Callable = Callable(self,"_set_button_properties")


func _ready():
	await owner.ready
	minMoveList = owner.minionData.MinionMoves
	for i in len(minMoveList):
		setProperties.bind(get("button"+str(i+1)),minMoveList[i]).call()
	self.connect("moveUsed",_on_move_used)

#region Setting Up The Buttons
	if button1.has_meta("Move"):
		button1.connect("pressed",buttonPressed.bind(button1.get_meta("Move")))
	if button2.has_meta("Move"):
		button2.connect("pressed",buttonPressed.bind(button2.get_meta("Move")))
	if button3.has_meta("Move"):
		button3.connect("pressed",buttonPressed.bind(button3.get_meta("Move")))
	if button4.has_meta("Move"):
		button4.connect("pressed",buttonPressed.bind(button4.get_meta("Move")))
	if button5.has_meta("Move"):
		button5.connect("pressed",buttonPressed.bind(button5.get_meta("Move")))
	if button6.has_meta("Move"):
		button6.connect("pressed",buttonPressed.bind(button6.get_meta("Move")))
#endregion

func _set_button_properties(button : TextureButton,move : MoveData):
	button.set_meta("Move",load(move.resource_path))
	button.texture_normal = move.sprite

#This will relay the signal from this to the minion
func _on_move_used(move):
	emit_signal("moveUsed",move)

func _on_select_time(moveEff : Array[MoveEffects]):
	var target
	var target_no
	var select_type
	for effect:MoveEffects in moveEff:
		if effect.override_properties:
			target_no = effect.targetNo
			target = effect.target
			select_type = effect.targetSelector

#Just used for relaying signal to The MoveSelector Scene from the button
func _pressed(move : MoveData):
	_on_move_used(move.duplicate())
