extends Control

var minMoveList : Array[MoveData]

@onready var button1 : TextureButton = %Move1  
@onready var button2 : TextureButton = %Move2
@onready var button3 : TextureButton = %Move3
@onready var button4 : TextureButton = %Move4
@onready var button5 : TextureButton = %Move5
@onready var button6 : TextureButton = %Move6

signal selectTime(target,no)

var moveUsed : Callable = Callable(self,"_on_move_used")
var setTexture : Callable = Callable(self,"_set_button_texture")


func _ready():
	await owner.ready
	minMoveList = get_parent().minionData.MinionMoves
	for i in len(minMoveList):
		setTexture.bind(get("button"+str(i+1)),minMoveList[i]).call()
	self.connect("selectTime",_on_select_time)
	if button1.has_meta("Move"):
		button1.connect("pressed",moveUsed.bind(button1.get_meta("Move")))
	if button2.has_meta("Move"):
		button2.connect("pressed",moveUsed.bind(button2.get_meta("Move")))
	if button3.has_meta("Move"):
		button3.connect("pressed",moveUsed.bind(button3.get_meta("Move")))
	if button4.has_meta("Move"):
		button4.connect("pressed",moveUsed.bind(button4.get_meta("Move")))
	if button5.has_meta("Move"):
		button5.connect("pressed",moveUsed.bind(button5.get_meta("Move")))
	if button6.has_meta("Move"):
		button6.connect("pressed",moveUsed.bind(button6.get_meta("Move")))

func _set_button_texture(button : TextureButton,move : MoveData):
	button.set_meta("Move",load(move.resource_path))
	button.texture_normal = move.sprite

func _on_move_used(move):
	emit_signal("selectTime",move.effects)

func _on_select_time(moveEff : Array[MoveEffects]):
	var target
	var target_no
	var select_type
	for effect:MoveEffects in moveEff:
		if effect.override_properties:
			target_no = effect.targetNo
			target = effect.target
			select_type = effect.targetSelector
		
