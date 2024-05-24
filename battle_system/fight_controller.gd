extends Node2D

signal move_complete
signal cycle_complete

var team1 : Array[Minion]
var team2 : Array[Minion]
var turn_order : Array[Minion]
var turn : int = -1
var last_effect : bool = false
var selector = SelectionManager.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

#Will be executed when play is pressed
func start(team_1 : Array[MinionData],team_2 : Array[MinionData]):
	_setup_minions(team_1,1) # team_1 is MinionData, team_2 is the minion itself
	_setup_minions(team_2,2)
	_minion_speed_changed()
	_update_turn()

func _minion_selected(minion : Minion):
	selector.hitlist.append(minion)
	selector.remaining_targets -= 1
	selector.possible_targets.erase(minion)
	if selector.remaining_targets == 0 or len(selector.possible_targets) == 0:
		selector.hit_targets()
		emit_signal("move_complete")

func _move_selected(minion : Minion, move : MoveData):
	for effect in move.effects:
		randomize()
		_apply_filter(minion,effect)
		
		if move.effects.find(effect) == len(move.effects)-1:
			last_effect = true
			
		if effect.override_properties == true:
			selector.hitlist.clear()
			if minion:
				selector._set_effect(effect,minion)
		
		await move_complete
		
		if last_effect == true:
			last_effect = false
			_update_turn()

func _on_death(minion):
	if turn_order.find(minion) != len(turn_order)-1\
	or turn_order.find(minion) != 0:
		turn -= 1
	selector.hitlist.erase(minion)
	turn_order.erase(minion)
	team1.erase(minion)
	team2.erase(minion)

func _apply_filter(minion : Minion, effect : MoveEffects):
	if minion.get_meta("team") == 1:
		if effect.targeted_team == 0:
			get_tree().call_group("Team2","show_click_detector")
			selector.possible_targets = get_tree().get_nodes_in_group("Team2")
		else:
			get_tree().call_group("Team1","show_click_detector")
			selector.possible_targets = get_tree().get_nodes_in_group("Team1")
	else:
		if effect.targeted_team == 0:
			get_tree().call_group("Team1","show_click_detector")
			selector.possible_targets = get_tree().get_nodes_in_group("Team1")
		else:
			get_tree().call_group("Team2","show_click_detector")
			selector.possible_targets = get_tree().get_nodes_in_group("Team2")

func _update_turn():
	if len(turn_order) == 0: return
	if turn >= len(turn_order)-1:
		emit_signal("cycle_complete")
		turn = 0
	else: turn += 1
	turn_order[turn].move_menu.show()

func _setup_minions(team : Array[MinionData],teamIndex : int):
	var k := 1
	for minion in team:
		var minion_instance : Minion = load(minion.scene).instantiate() #Load all selected minions
		
		match teamIndex:
			1:
				get_node("L_Minions/L" + str(k)).add_child(minion_instance) #INsert the loaded minion to the scene
				team1.append(minion_instance) 
				minion_instance.set_meta("team",1)
				minion_instance.add_to_group("Team1")
			2:
				get_node("R_Minions/R" + str(k)).add_child(minion_instance) #INsert the loaded minion to the scene
				team2.append(minion_instance)
				minion_instance.set_meta("team",2)
				minion_instance.add_to_group("Team2")
		k+=1
		
		minion_instance.minion_data = minion_instance.minion_data.duplicate() #For unique editing
		turn_order.append(minion_instance) #Store the UNIQUE reference to an array
		minion_instance.minion_died.connect(_on_death)
		minion_instance.minion_selected.connect(_minion_selected)
		minion_instance.minion_move_selected.connect(_move_selected)
		move_complete.connect(func():
			minion_instance.click_detector.hide())
		cycle_complete.connect(minion_instance._apply_overtime_effects)
		
		minion_instance.get_node("Sprite").flip_h = true if teamIndex == 1 else false #Set correct orientation

func _minion_speed_changed():
	#Now we determine the turn order using bubble sort
	for i in len(turn_order)-1:
		for j in len(turn_order)-1-i:
			if turn_order[j].minion_data.speed > turn_order[j+1].minion_data.speed:
				var temp = turn_order[j]
				turn_order[j] = turn_order[j+1]
				turn_order[j+1] = temp

	turn_order.reverse()#This will make turn order go from highest speed to lowest speed



######################################################################################################


class SelectionManager:
	signal selectActivated(minion,targets,targeter)
	signal move_complete

	var targeter : Minion
	var effect : MoveEffects
	var hitlist : Array[Minion] = []
	var remaining_targets : int
	var possible_targets : Array = []

	enum targetSelectors{
		Player,
		Random,
		All
	}

	enum targetType{
		Enemy,
		Ally,
		Self
	}


	func hit_targets():
		for minion in hitlist:
			if minion:
				if effect.effect == effect.Effect.DAMAGESORHEALS:
					if effect.max_damage == 0: minion.take_damage(effect.damage)
					else: minion.take_damage(randi_range(effect.damage,effect.max_damage))
					print(minion.minion_data.name + " has been hit for " + str(effect.damage))

	#func _select_hitlist(minion : Minion,team1 : Array[Minion],team2 : Array[Minion],teamToSelect : int):
		#if team1.find(minion) != -1:
			#match teamToSelect:
				#0:#Enemy team
					#if len(team2) <= targets_to_get or effect.targetSelector == 3:
						#hitlist.append_array(team2)
					#else:
						#var i = 0
						#var temp : Array[int] = []
						#while i < targets_to_get:
							#randomize()
							#var idx = randi_range(0,len(team2)-1)
							#if temp.find(idx) == -1:
								#hitlist.append(team2[idx])
								#temp.append(idx)
								#i += 1
							#else: continue
					#_hit_targets()
				#1:#Own team
					#if len(team1) <= targets_to_get or effect.targetSelector == 3: hitlist.append_array(team1)
#
					#else:
						#var i = 0
						#var temp : Array[int] = []
						#while i < targets_to_get:
							#randomize()
							#var idx = randi_range(0,len(team1)-1)
							#if temp.find(idx) == -1:
								#hitlist.append(team1[idx])
								#temp.append(idx)
								#i += 1
							#else: continue
					#_hit_targets()
#
		#if team2.find(minion) != -1:
			#match teamToSelect:
				#0:
					#if len(team1) <= targets_to_get or effect.targetSelector == 3: hitlist.append_array(team1)
#
					#else:
						#for i in range(0,targets_to_get):
							#var idx = randi_range(0,len(team1)-1)
							#hitlist.append(team1[idx])
					#_hit_targets()
#
				#1:
					#if len(team2) <= targets_to_get or effect.targetSelector == 3: hitlist.append_array(team2)
#
					#else:
						#var i = 0
						#var temp : Array[int] = []
						#while i < targets_to_get:
							#randomize()
							#var idx = randi_range(0,len(team2)-1)
							#if temp.find(idx) == -1:
								#hitlist.append(team2[idx])
								#temp.append(idx)
								#i += 1
							#else: continue
					#_hit_targets()

	func _set_effect(effect, targeter):
		self.effect = effect
		self.targeter = targeter
		self.remaining_targets = effect.target_no
