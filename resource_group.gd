@tool
class_name ResourceGroup extends Resource

@export var run : bool = false:
	set(val):
		run = val
		if val:
			scan()

##Enter the path to the folder of resources you want to search
@export_dir var searchPath : String = ""
@export var pathList : Array[String]

func _init() -> void:
	if Engine.is_editor_hint():
		EditorInterface.get_resource_filesystem().connect("filesystem_changed",scan)

func load_all_into() -> Array[MinionData]:
	var list : Array[MinionData]
	for path in pathList:
		list.append(load(path))
	return list

func scan():
	pathList.clear()
	var dir : Array = DirAccess.get_files_at(searchPath)
	for file : String in dir:
		pathList.append(searchPath + "/" + file)
	run = false
