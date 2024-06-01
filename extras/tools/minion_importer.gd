extends Node
class_name MinionImporter

@export_dir var sprite_path : String
@export_dir var scene_path : String
@export_dir var res_path : String
@export_file("*.csv") var csv_path : String
@export_file("*.tscn") var scene_template : String # Just create on temporarily and delete it later or smth

func _ready() -> void:
	var minion_db = FileAccess.open(csv_path,FileAccess.READ) # Open the csv file
	var minion_data = MinionData.new() # Create new minion instance
	var header = minion_db.get_csv_line() # Get top line
	
	
	while !minion_db.eof_reached():
		
		#region Creating and saving MinionData file
		var cur_min = minion_db.get_csv_line() # Get current minions data as an array 
		
		for stat in cur_min:
			# Get the index of the current stat(to match with the header to see which stat is being set
			var idx = cur_min.find(stat)
			
			# By default, all values in csv are strings, so we need to convert the numbers to int
			if stat.is_valid_int():
				stat = str_to_var(stat)
			
			# After 5, we have to set the types, which need to be set diffeerntly
			if idx <= 5:
				minion_data.set(header[idx],stat)
			if idx > 5:
				minion_data.set(header[idx],minion_data.MinionType.get(stat))
		
		minion_data.sprite = load(sprite_path + "/" + minion_data.name + ".png") # Load sprite
		# Save the path to where the scene will be created
		minion_data.scene = scene_path + "/"  + minion_data.name.to_lower() + ".tscn"
		# the path where the resource will be saved
		var res_save_path = res_path + "/" +  minion_data.name.to_lower() + ".tres"
		ResourceSaver.save(minion_data, res_save_path)
		#endregion
		
		
		#region Creating and saving scene file
		var scene = load(scene_template).instantiate()
		scene.minion_data = ResourceLoader.load(res_save_path)
		var min_save_path = scene_path + "/"  + minion_data.name.to_lower() + ".tscn"
		var export_scene : PackedScene = PackedScene.new()
		export_scene.pack(scene)
		ResourceSaver.save(export_scene, min_save_path)
		#endregion
