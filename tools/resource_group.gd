@tool
class_name ResourceGroup extends Resource

@export var run : bool = false:
	set(val):
		run = val
		if val:
			scan()

##Enter the path to the folder of resources you want to search
@export_dir var search_path : String = ""
@export var path_list : Array[String]

func load_all_into() -> Array[MinionData]:
	var list : Array[MinionData]
	for path in path_list:
		list.append(load(path))
	return list

func scan():
	path_list.clear()
	var dir : Array = DirAccess.get_files_at(search_path)
	for file : String in dir:
		path_list.append(search_path + "/" + file)
	run = false
