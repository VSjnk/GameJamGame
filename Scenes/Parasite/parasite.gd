extends CharacterBody2D

@onready var player = get_parent()

@onready var nav = $NavigationAgent2D
@onready var random_recalculate_path = $RandomRecalculatePath
@onready var constant_attack_time = $ConstantAttackTime

var errorOverride = 0

var direction : Vector2

var health = 50
var speed = 150
var _delta = 0
const accel = 10
const damage = 10



var active = false
#Finds the Player node as soon as it loads into the scene.
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_delta = delta
	if active:
		$Radius.look_at(player.global_position)
		if constant_attack_time.is_stopped():
			constant_attack_time.start()
		if random_recalculate_path.is_stopped():
			random_recalculate_path.start(randf_range(0.05, 0.1))
		if direction and speed and accel:
			velocity = velocity.lerp(direction * speed, accel * delta)
			var lookPos = direction
			if not global_position.is_equal_approx(lookPos):
				look_at(lookPos)
		move_and_slide()

#Decides if the parasite should attack.
func _on_visible_on_screen_notifier_2d_screen_entered():
	print("On screen!")
	active = true
	constant_attack_time.start()

func _on_visible_on_screen_notifier_2d_screen_exited():
	constant_attack_time.stop()

func _on_random_recalculate_path_timeout():
	nav.target_position = player.global_position
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()

func _on_constant_attack_time_timeout():
	print("Timer Done!")
	var bodies = $Radius.get_overlapping_bodies()
	for obj in bodies:
		print(obj)
		if obj.is_in_group("Player"):
			obj.hurt(damage)
			

func hurt(damage):
	health -= damage
	if health <= 0:
		queue_free()
