extends CharacterBody2D

@export var gravityForce = 1000

func _physics_process(delta):
	player_falling(delta)
	move_and_slide()



func player_falling(delta):
	if !is_on_floor():
		velocity.y += gravityForce * delta
