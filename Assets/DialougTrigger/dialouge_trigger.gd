extends Area2D

@export var DialougeText = ["PlaceholderText 1", "PlaceholderText 2"]

@onready var player = get_parent()
var errorOverride = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	while player.find_child("Player") == null:
		player = player.get_parent()
		if OS.is_debug_build():
			if player.find_child("Player"):
				print("Found Player! " + str(player))
			else:
				print("Script Failed!")
	await player.find_child("Player")
	player = player.find_child("Player")
	pass # Replace with function body.



func _on_body_entered(body):
	if body.is_in_group("Player"):
		for i in len(DialougeText):
			player.hud.queue_text(DialougeText[i])
		queue_free()
	pass # Replace with function body.
