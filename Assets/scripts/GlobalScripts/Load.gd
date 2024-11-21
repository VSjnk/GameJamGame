extends Node

var ProgressText = "Loading never started"
var progress = []
var scene_load_total_status = 0

var scenename = "res://Menus/MainMenu/MainMenu.tscn"
var newScene

# Called when the node enters the scene tree for the first time.
func Load(scene):
	scenename = scene
	ResourceLoader.load_threaded_request(scenename)
	
func _process(delta):
	scene_load_total_status = ResourceLoader.load_threaded_get_status(scenename,progress)
	ProgressText = "Loading " + str(floor(progress[0]*100)) + "%"
	if scene_load_total_status == ResourceLoader.THREAD_LOAD_LOADED:
		ProgressText = "Loading Level, Get ready!"
		newScene = ResourceLoader.load_threaded_get(scenename)
	if scene_load_total_status == ResourceLoader.THREAD_LOAD_FAILED:
		ProgressText = "yo shit broke (loading failed)"

# Change The Scene to the loaded scene
func changeToLoadedScene():
	if newScene != null:
		get_tree().change_scene_to_packed(newScene)

# Output the loaded scene for spawning a child.
func loadAsChild():
	if newScene != null:
		var ChildScene = newScene.instantiate()
		return ChildScene
