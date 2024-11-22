extends CanvasLayer

const LOADING = "res://Menus/LoadingScreen/Loading.tscn"

func _on_start_pressed():
	Globals.scenename = "res://Level/tile_map_tests.tscn"
	get_tree().change_scene_to_file(LOADING)
