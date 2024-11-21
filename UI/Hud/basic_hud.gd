extends Control

@onready var player = get_parent()

@onready var stamina : TextureProgressBar = $Stamina
@onready var health : TextureProgressBar = $Health
@onready var wrn = $Background/Wrn
@onready var injured = $Injurd


var flashTime = 0
var _delta = 0
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
	_delta = delta
	stamina.value = player.stamina
	health.value = player.health
	
	if player.health <= 20:
		flashTime += delta
		print(flashTime)
		if flashTime >= player.health / 100.0:
			wrn.visible = !wrn.visible
			await get_tree().process_frame
			flashTime = 0
	else:
		wrn.hide()
	pass


func hurtUI():
	injured.modulate = Color(1,1,1,1)
	const range = 125.0
	for i in range(range):
		if i != 0:
			#print(1 - (i / range))
			injured.modulate = Color(1,1,1,1 - (i / range))
			await get_tree().process_frame
	injured.modulate = Color(1,1,1,0)
