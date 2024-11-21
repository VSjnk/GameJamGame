extends CharacterBody2D

var SPEED = 150
var stamina = 100

@onready var animated_sprites = $AnimatedSprites

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
			stamina += 0.5
			
	#Handels your sprinting
	if Input.is_action_pressed("Sprint") and stamina > 0:
		SPEED = 250
		#Looses Stamina over time
		stamina -= 1
	else:
		SPEED = 150

func _input(event):
	if event is InputEventKey:
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
				pass
			#right
			1:
				animated_sprites.find_child("Right").show()
				animated_sprites.find_child("Left").hide()
				
		#Use for actions!
		pass
