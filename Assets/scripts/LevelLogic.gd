extends Node2D

@onready var dialouge = self

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Looking for hud...")
	if dialouge.find_child("Player").find_child("Camera2D").find_child("CanvasLayer").find_child("BasicHud"):
		dialouge = find_child("Player").find_child("Camera2D").find_child("CanvasLayer").find_child("BasicHud")
	else:
		return
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
