extends CharacterBody2D

const SPEED = 50

func _physics_process(delta):
	var direction = Vector2(Input.get_axis("Left","Right"),Input.get_axis("Up","Down"))
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()

func _input(event):
	if event is InputEventKey:
		
		pass
