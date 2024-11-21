extends Node2D

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		body.parasiteLeft += 125
		body.heal(5)
		if body.parasiteLeft > 1000:
			body.parasiteLeft = 1000
		queue_free()
	pass # Replace with function body.
