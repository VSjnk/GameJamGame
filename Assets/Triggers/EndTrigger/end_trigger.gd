extends Node2D

@export var triggerID = 0

#Trigger IDs:
# 0 - Good Ending
# 1 - Bad Ending
const LOADING = "res://Menus/LoadingScreen/Loading.tscn"
const GOOD_ENDING = "res://Scenes/Endings/GoodEnding/goodEnding.tscn"
const BAD_ENDING = "res://Scenes/Endings/BadEnding/BadEnding.tscn"

# Called when the node enters the scene tree for the first time.
func interact():
	match triggerID:
		0:
			Globals.scenename = GOOD_ENDING
		1:
			Globals.scenename = BAD_ENDING
	get_tree().change_scene_to_file(LOADING)
