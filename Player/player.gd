extends CharacterBody2D

var SPEED = 150
var stamina = 100

func _physics_process(delta):
	var direction = Vector2(Input.get_axis("Left","Right"),Input.get_axis("Up","Down"))
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()
	
	#Recharges your stamina
	print(stamina)
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
		
		
		
		pass
