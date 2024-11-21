extends CharacterBody2D

@onready var player = get_parent()

@onready var nav = $NavigationAgent2D
@onready var random_recalculate_path = $RandomRecalculatePath

var direction : Vector2

var health = 50
var speed = 50
var _delta = 0
const accel = 3



var active = true
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_delta = delta
	if active:
		#random_recalculate_path.start(0.05)
		if random_recalculate_path.is_stopped():
			random_recalculate_path.start(randf_range(0.05, 0.1))
		if direction and speed and accel:
			velocity = velocity.lerp(direction * speed, accel * delta)
			var lookPos = direction
			if not global_position.is_equal_approx(lookPos):
				look_at(lookPos)
		move_and_slide()
		


func _on_visible_on_screen_notifier_2d_screen_entered():
	active = true


func _on_random_recalculate_path_timeout():
	print("Getting path!")
	nav.target_position = player.global_position
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
		
