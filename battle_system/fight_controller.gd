extends Node2D

signal select_mode_activated(minion : Minion, move : MoveEffects)
signal effect_complete
signal move_complete
signal cycle_complete

enum targetSelectors{
	PLAYER,
	RANDOM,
	ALL
}
enum targetType{
	ENEMY,
	ALLY,
	SELF
}

var targeter : Minion
var cur_effect : MoveEffects
var hitlist : Array[Minion] = []
var remaining_targets : int
var possible_targets : Array[Minion] = []

var team1 : Array[Minion]
var team2 : Array[Minion]
var turn_order : Array[Minion]
var turn : int = -1
var last_effect : bool = false
var select_mode := false

func _ready() -> void:
	select_mode_activated.connect(_select_minions)

func _process(delta: float) -> void:
	if select_mode:
		if remaining_targets == 0 or possible_targets.size() == 0:
			emit_signal("effect_complete")
			select_mode = false

func _select_minions(minion : Minion, effect : MoveEffects):
	possible_targets = _get_possible_targets(minion,effect)
	match effect.target_selector:
	
		effect.TargetSelector.PLAYER:
			for target : Minion in possible_targets:
				target.show_click_detector()
				select_mode = true
			
		effect.TargetSelector.RANDOM:
			for i in range(0,remaining_targets):
				if possible_targets.size() == 0: break
				var to_be_added = possible_targets[randi_range(0,possible_targets.size()-1)] 
				hitlist.append(to_be_added)
				possible_targets.erase(to_be_added)
			
			await get_tree().create_timer(0.01).timeout
			emit_signal("effect_complete")
		
		effect.TargetSelector.SELF:
			hitlist.append(minion)
			await get_tree().create_timer(0.01).timeout
			emit_signal("effect_complete")
		
		effect.TargetSelector.ALL:
			hitlist.append_array(possible_targets)
			await get_tree().create_timer(0.01).timeout
			emit_signal("effect_complete")

func _move_selected(minion : Minion, move : MoveData):
	for effect in move.effects:
		_set_effect(effect,minion)
		if effect.new_selection:
			possible_targets.clear()
			hitlist.clear()
			emit_signal("select_mode_activated",minion,effect)
			await effect_complete
		
		_execute_move()
	
	_update_turn()

#Will be executed when play is pressed
func start(team_1 : Array[MinionData],team_2 : Array[MinionData]):
	_setup_minions(team_1,1) # team_1 is MinionData, team_2 is the minion itself
	_setup_minions(team_2,2)
	_minion_speed_changed()
	_update_turn()

func _minion_selected(minion : Minion):
	hitlist.append(minion)
	remaining_targets -= 1
	possible_targets.erase(minion)

func _on_death(minion):
	if turn_order.find(minion) != len(turn_order)-1\
	or turn_order.find(minion) != 0:
		turn -= 1
	hitlist.erase(minion)
	possible_targets.erase(minion)
	turn_order.erase(minion)
	team1.erase(minion)
	team2.erase(minion)

func _get_possible_targets(minion : Minion, effect : MoveEffects):
	if minion.get_meta("team") == 1:
		if effect.targeted_team == 0: # Opponent team
			return team2.duplicate()
		else:
			return team1.duplicate()
	else: # Minion belongs to 2nd team
		if effect.targeted_team == 0:
			return team1.duplicate()
		else:
			return team2.duplicate()

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
		effect_complete.connect(func():
			minion_instance.click_detector.hide())
		cycle_complete.connect(minion_instance.update_overtime_effects)
		
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

func _execute_move():
	hit_targets()


func hit_targets():
	for minion in hitlist:
		if minion:
			if cur_effect.effect == cur_effect.Effect.DAMAGESORHEALS:
				if cur_effect.turn_duration == 0:
					if cur_effect.max_damage == 0: minion.take_damage(cur_effect.damage)
					else: minion.take_damage(randi_range(cur_effect.damage,cur_effect.max_damage))
				else:
					minion.add_active_effect(cur_effect)
			elif cur_effect.effect == cur_effect.Effect.BUFFSORDEBUFFS:
				minion.add_passive_effect(cur_effect)

func _set_effect(effect, minion):
	cur_effect = effect
	targeter = minion
	remaining_targets = effect.target_no
