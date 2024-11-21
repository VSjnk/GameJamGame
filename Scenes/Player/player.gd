extends CharacterBody2D

class_name Player

var SPEED = 150
var health = 100
var stamina = 100

var timer : SceneTreeTimer

const Walk_Speed = 150
const Sprint_Speed = 250
const stamina_recharge = 0.5

@onready var animated_sprites = $AnimatedSprites
@onready var hud = $Camera2D/CanvasLayer/BasicHud


func _physics_process(delta):
	#Handels basic movement
	var direction = Vector2(Input.get_axis("Left","Right"),Input.get_axis("Up","Down"))
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()
	
	#Recharges your stamina
	if !Input.is_action_pressed("Sprint"):
		if stamina < 100:
			stamina += stamina_recharge
			
	#Handels your sprinting
	if Input.is_action_pressed("Sprint") and stamina >= stamina_recharge:
		SPEED = 250
		#Looses Stamina over time
		stamina -= 1
	else:
		SPEED = 150

func _input(event):
	if Input.is_action_just_pressed("Sprint"):
		hurt(25)
	if event is InputEventKey or event is InputEventAction:
		var direction = Vector2(Input.get_axis("Left","Right"),Input.get_axis("Up","Down"))
		if direction != Vector2(0,0):
			for i in animated_sprites.get_children():
				i.hide()
		var Xaxis = int(direction.x)
		var Yaxis = int(direction.y)
		match Yaxis:
			#up
			-1:
				animated_sprites.find_child("Up").show()
				animated_sprites.find_child("Down").hide()
				
			#down
			1:
				animated_sprites.find_child("Down").show()
				animated_sprites.find_child("Up").hide()
		match Xaxis:
			#left
			-1:
				animated_sprites.find_child("Left").show()
				animated_sprites.find_child("Right").hide()
			#right
			1:
				animated_sprites.find_child("Right").show()
				animated_sprites.find_child("Left").hide()

func hurt(damage):
	health -= damage
	hud.hurtUI()
	print(health)
	if health <= 0:
		pass
		#get_tree().reload_current_scene()
