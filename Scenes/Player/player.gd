extends CharacterBody2D

class_name Player

var SPEED = 300
var health = 100
var stamina = 100
var parasiteLeft = 1000

var timer : SceneTreeTimer

const Walk_Speed = 300
const Sprint_Speed = 450
const stamina_recharge = 0.25

const Damage = 25

@onready var animated_sprites = $AnimatedSprites
@onready var hud = $Camera2D/CanvasLayer/BasicHud
@onready var range = $AnimatedSprites/Range


func _physics_process(delta):
	#Handels basic movement
	var direction = Vector2(Input.get_axis("Left","Right"),Input.get_axis("Up","Down"))
	if direction:
		#Handels your sprinting
		parasiteLeft -= randf_range(0.0,1.0)
		if parasiteLeft <= 0:
			hurt(randi_range(1,25))
			parasiteLeft = 1000
		if Input.is_action_pressed("Sprint") and stamina >= stamina_recharge:
			SPEED = Sprint_Speed
			#Looses Stamina over time
			stamina -= 0.1
		else:
			SPEED = Walk_Speed
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()
	
	#Recharges your stamina
	if !Input.is_action_pressed("Sprint"):
		if stamina < 100:
			stamina += stamina_recharge
			
	

func _input(event):
	
	if Input.is_action_just_pressed("ui_page_down"):
		hurt(25)
	if Input.is_action_just_pressed("ui_page_up"):
		heal(25)
	if event is InputEventMouseMotion:
		animated_sprites.look_at(get_global_mouse_position())
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("Attack"):
			var bodies = range.get_overlapping_bodies()
			for obj in bodies:
				if obj.is_in_group("parasite"):
					obj.hurt(Damage)
func hurt(damage):
	health -= damage
	hud.hurtUI()
	if health <= 0:
		get_tree().reload_current_scene()

func heal(ammount):
	health += ammount
	if health > 100:
		health = 100
