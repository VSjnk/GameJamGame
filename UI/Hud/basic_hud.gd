extends Control

@onready var player = get_parent()

@onready var stamina : TextureProgressBar = $Stamina
@onready var health : TextureProgressBar = $Health
@onready var background = $Background

@onready var wrn = $Background/Wrn
@onready var injured = $Background/Injurd

var maxPlayerHealth = 100.0
var hudIncrement = 25.0

#because I'm stupid, I don't know how to make delta time global so this will have to do.
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
	
	maxPlayerHealth = float(player.health)
	hudIncrement = maxPlayerHealth / (background.get_child_count() - 3.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_delta = delta
	stamina.value = player.stamina
	health.value = player.health
	if player.health <= 20:
		flashTime += delta
		if flashTime >= player.health / 100.0:
			wrn.visible = !wrn.visible
			await get_tree().process_frame
			flashTime = 0
	else:
		wrn.hide()
	var hudValue = ceili(player.health / hudIncrement)
	if background.find_child("Hud" + str(hudValue)) != null:
		background.find_child("Hud" + str(hudValue)).show()
	else:
		if hudValue <= 0:
			background.find_child("Hud0").show()
		else:
			background.find_child("Hud4").show()
	if background.find_child("Hud" + str(hudValue + 1)) != null:
		background.find_child("Hud" + str(hudValue + 1)).hide()
	if background.find_child("Hud" + str(hudValue - 1)) != null:
		background.find_child("Hud" + str(hudValue - 1)).hide()
	
	pass

#This function controls the hurt flash speed with delta
func hurtUI():
	injured.modulate = Color(1,1,1,1)
	var range = 255.0
	range = range * (_delta * 10)
	print(range)
	for i in range(range):
		if i != 0:
			injured.modulate = Color(1,1,1,1 - (i / range))
			if player.health > 0:
				await get_tree().process_frame
	injured.modulate = Color(1,1,1,0)
