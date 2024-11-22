extends Control

@onready var player = get_parent()

@onready var stamina : TextureProgressBar = $Stamina
@onready var health : TextureProgressBar = $Health
@onready var parasite_time : TextureProgressBar = $ParasiteTime

@onready var background = $Background
@onready var text_box = $TextBox
@onready var Dialogue  : Label = $TextBox/MarginContainer/Dialogue 

@onready var text_edit = $PasswordPrompt/TextEdit

@onready var wrn = $Background/Wrn
@onready var injured = $Background/Injurd

var maxPlayerHealth = 100.0
var hudIncrement = 25.0

@onready var password_prompt = $PasswordPrompt

@onready var enter_password = $PasswordPrompt/EnterPassword
@onready var back_button = $PasswordPrompt/BackButton

var password = ""

const CHAR_READ_RATE = 0.05

#because I'm stupid, I don't know how to make delta time global so this will have to do.
var flashTime = 0
var dialougeTime = 0
var _delta = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	show()
	while player.find_child("Player") == null:
		player = player.get_parent()
		if OS.is_debug_build():
			if player.find_child("Player"):
				print("Found Player! " + str(player))
			else:
				print("Script Failed!")
	await player.find_child("Player")
	player = player.find_child("Player")
	
	maxPlayerHealth = float(player.health)
	hudIncrement = maxPlayerHealth / (background.get_child_count() - 3.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#This is how the main part of the UI is shown.
	_delta = delta
	parasite_time.visible = Input.is_action_pressed("CheckParasite")
	parasite_time.value = player.parasiteLeft / 10
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
	
	#Dialouge State Checking here
	check_state(delta)
	

#This function controls the hurt flash speed with delta
func hurtUI():
	injured.modulate = Color(1,1,1,1)
	var range = 255.0
	range = range * (_delta * 10)
	for i in range(range):
		if i != 0:
			injured.modulate = Color(1,1,1,1 - (i / range))
			if player.health > 0:
				await get_tree().process_frame
	injured.modulate = Color(1,1,1,0)

#This all handels the Dialogue  text

enum State {
	READY,
	READING,
	FINISHED
}

var isInDialogue = false
var textTween : Tween
var current_state = State.READY
var text_queue = []

func queue_text(next_text):
	text_queue.push_back(next_text)

func showDialogue():
	get_tree().paused = true
	var TextBox = text_queue.pop_front()
	text_box.show()
	Dialogue .text = TextBox
	change_state(State.READING)
	if textTween:
		textTween.kill()
	textTween = get_tree().create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	textTween.finished.connect(self.textTween_Finished)
	textTween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	textTween.tween_property(Dialogue , "visible_ratio", 1.0, len(TextBox) * CHAR_READ_RATE)

func textTween_Finished():
	change_state(State.FINISHED)

func change_state(state):
	current_state = state

func check_state(delta):
	match current_state:
		State.READY:
			Dialogue.text = ""
			Dialogue.visible_ratio = 0
			text_box.hide()
			if !text_queue.is_empty():
				showDialogue()
		State.READING:
			if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("Attack"):
				if textTween:
					textTween.stop()
				Dialogue .visible_ratio = 1
				change_state(State.FINISHED)
		State.FINISHED:
			$TextBox/V.show()
			dialougeTime += delta
			if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("Attack") or dialougeTime >= 30.0:
				$TextBox/V.hide()
				change_state(State.READY)
				get_tree().paused = false
				dialougeTime = 0


func _on_text_edit_text_changed():
	password = text_edit.text
	pass # Replace with function body.
