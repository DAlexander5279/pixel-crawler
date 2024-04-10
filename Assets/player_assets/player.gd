extends CharacterBody2D

@onready var player_sprite = $"Player-idle-1"

@export var gravityForce = 1000
@export var playerSpeed = 300

func _physics_process(delta):
	player_falling(delta)
	player_move(delta)
	move_and_slide()



func player_falling(delta):
	if !is_on_floor():
		velocity.y += gravityForce * delta
		
func player_move(delta):
	
	if movement_direction():
		velocity.x = movement_direction() * playerSpeed
	else:
		velocity.x = move_toward(velocity.x, 0 , playerSpeed)
		
		
	if movement_direction() != 0:
		player_sprite.flip_h = false if movement_direction() > 0 else true
	
func movement_direction():
	var direction = Input.get_axis("move_left", "move_right")
	return direction
