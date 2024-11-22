extends CharacterBody2D

var tween : Tween
@export var password = ""

@onready var player = get_parent()
var errorOverride = 0


@onready var SetRot = rotation
var ease = Tween.EASE_OUT
var trans = Tween.TRANS_ELASTIC


const time = 2.5


enum doorState {
	OPEN,
	CLOSED
}

var current_Door_State = doorState.CLOSED

func _ready():
	while player.find_child("Player") == null:
		player = player.get_parent()
		if !player.find_child("Player"):
			errorOverride += 1
			if OS.is_debug_build():
				print("Script Failed! Retrying for the " + str(errorOverride) + " time...")
			if errorOverride > 500:
				print("Cannot find player! Removing...")
				queue_free()
		elif OS.is_debug_build():
			print("Found Player! " + str(player))
				
	await player.find_child("Player")
	player = player.find_child("Player")
	if OS.is_debug_build():
		print(SetRot)

func interact():
	if OS.is_debug_build():
		print(current_Door_State)
	if password != "":
		player.hud.password_prompt.show()
		if player.hud.password_prompt.visible:
			print("asking player for password...")
			await get_tree().process_frame
			if player.hud.enter_password.pressed and is_in_group("Door"):
				if player.hud.password == password:
					match current_Door_State:
						doorState.OPEN:
							closed()
						doorState.CLOSED:
							open()
					player.hud.password_prompt.visible = false
			if player.hud.back_button.pressed:
				player.hud.password_prompt.visible = false
	

func open():
	current_Door_State = doorState.OPEN
	if tween:
		tween.kill()
	tween = get_tree().create_tween().set_ease(ease).set_trans(trans)
	tween.tween_property(self, "rotation", deg_to_rad(90) + SetRot, time)

func closed():
	current_Door_State = doorState.CLOSED
	if tween:
		tween.kill()
	tween = get_tree().create_tween().set_ease(ease).set_trans(trans)
	tween.tween_property(self, "rotation", deg_to_rad(0) + SetRot, time)
