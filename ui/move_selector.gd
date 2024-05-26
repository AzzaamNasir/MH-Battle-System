class_name MoveMenu
## This displays all the moves a minion has and allows the player to select the moves
extends Control

signal move_selected(move : MoveData)

var move_list : Array[MoveData]
var pressed : Callable = Callable(self,"pressed")

#region Setting up variables for the move buttons
@onready var button1 : TextureButton = %Move1
@onready var button2 : TextureButton = %Move2
@onready var button3 : TextureButton = %Move3
@onready var button4 : TextureButton = %Move4
@onready var button5 : TextureButton = %Move5
@onready var button6 : TextureButton = %Move6
@onready var energy_bar: TextureProgressBar = %Bar
@onready var energy_label: Label = %Label
#endregion


func _ready():
	await owner.ready
	# Set up energy displayer
	energy_bar.max_value = owner.minion_data.energy
	energy_bar.value = energy_bar.max_value
	energy_label.text = str(energy_bar.value) + "/" + str(energy_bar.max_value)
	# Adds all the moves the minion has to move_list
	move_list = owner.minion_data.moves
	
	_setup_buttons()


func _setup_buttons():
	for i in len(move_list):
		# Creates a lambda function, then bind all the button variables to it one by one
		Callable(func(button : TextureButton, move : MoveData):
			button.set_meta("Move",load(move.resource_path))
			button.texture_normal = move.sprite)\
			.bind(get("button"+str(i+1)),move_list[i])\
			.call() # Bind the button to the function and then call it
	
	#region Adding button signals
	if button1.has_meta("Move"): # If the 1st button has a move attached to it
		button1.pressed.connect(func(): # If it is pressed, Then run this code
			hide() # Hide the move selector
			owner.move_selected(button1.get_meta("Move")) # Call move_selected() in the minion
			)
	
	if button2.has_meta("Move"): # If the 2nd button has a move and so on for the rest
		button2.pressed.connect(func():
			hide()
			owner.move_selected(button2.get_meta("Move"))
			)
	
	if button3.has_meta("Move"):
		button3.pressed.connect(func():
			hide()
			owner.move_selected(button3.get_meta("Move"))
			)
	
	if button4.has_meta("Move"):
		button4.pressed.connect(func():
			hide()
			owner.move_selected(button4.get_meta("Move"))
			)
	
	if button5.has_meta("Move"):
		button5.pressed.connect(func():
			hide()
			owner.move_selected(button5.get_meta("Move"))
			)
	
	if button6.has_meta("Move"):
		button6.pressed.connect(func():
			hide()
			owner.move_selected(button6.get_meta("Move"))
			)
	#endregion
