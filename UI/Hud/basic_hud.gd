extends Control

@onready var player = get_parent()

@onready var stamina : Label = $Stamina
@onready var health : Label = $Health


# Called when the node enters the scene tree for the first time.
func _ready():
	while player.find_child("Player") == null:
		player = player.get_parent()
		if player.find_child("Player"):
			print("Found Player! " + str(player))
		else:
			print("Script Failed!")
	await player.find_child("Player")
	player = player.find_child("Player")
	print("Player set as! " + str(player))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	stamina.text = "Stamina: " + str(floor(player.stamina))
	health.text = "Health: " + str(player.health)
	pass
