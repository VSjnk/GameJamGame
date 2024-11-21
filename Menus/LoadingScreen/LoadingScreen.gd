extends CanvasLayer

@onready var ProgressText = $Progress
var progress = []
var scene_load_total_status = 0

#var scenename = "res://Menus/MainMenu/MainMenu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	ResourceLoader.load_threaded_request(Globals.scenename)
	
func _process(delta):
	scene_load_total_status = ResourceLoader.load_threaded_get_status(Globals.scenename,progress)
	ProgressText.text = "Loading " + str(floor(progress[0]*100)) + "%"
	if scene_load_total_status == ResourceLoader.THREAD_LOAD_LOADED:
		ProgressText.text = "Loading Level, Get ready!"
		var newScene = ResourceLoader.load_threaded_get(Globals.scenename)
		get_tree().change_scene_to_packed(newScene)
	if scene_load_total_status == ResourceLoader.THREAD_LOAD_FAILED:
		ProgressText.text = "yo shit broke (loading failed)"
