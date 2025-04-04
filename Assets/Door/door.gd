extends CharacterBody2D

var tween : Tween
@export var password = ""
var unlocked = false

@onready var player = get_parent()
@onready var audio_stream_player = $AudioStreamPlayer

var errorOverride = 0


@onready var SetRot = rotation
const moveBy = 300
var ease = Tween.EASE_OUT
var trans = Tween.TRANS_ELASTIC


const time = 1.3


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
	if password != "" and !unlocked:
		get_tree().paused = true
		player.hud.password_prompt.show()
		while player.hud.password_prompt.visible:
			print("asking player for password...")
			await get_tree().process_frame
			if player.hud.enter_password.button_pressed:
				if player.hud.password == password:
					get_tree().paused = false
					unlocked = true
					match current_Door_State:
						doorState.OPEN:
							closed()
						doorState.CLOSED:
							open()
					print("Closed via Enter")
					player.hud.password_prompt.hide()
			if player.hud.back_button.button_pressed:
				print("Closed via back")
				get_tree().paused = false
				player.hud.password_prompt.hide()
	else:
		match current_Door_State:
			doorState.OPEN:
				closed()
			doorState.CLOSED:
				open()

func open():
	audio_stream_player.play()
	var forward = Vector2(cos(SetRot), sin(SetRot)) * moveBy + global_position
	print(forward)
	current_Door_State = doorState.OPEN
	if tween:
		tween.kill()
	tween = get_tree().create_tween().set_ease(ease).set_trans(trans).set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "position", forward, time)

func closed():
	audio_stream_player.play()
	var forward = Vector2(cos(SetRot), sin(SetRot)) * moveBy * -1 + global_position
	current_Door_State = doorState.CLOSED
	if tween:
		tween.kill()
	tween = get_tree().create_tween().set_ease(ease).set_trans(trans).set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "position", forward, time)
