extends CharacterBody2D

@onready var player_sprite = $"Player-idle-1"

@export var gravityForce : int = 1000
@export var playerSpeed : int = 300
@export var jumpForce : int = -300
@export var max_jumps : int = 1
@export var current_jumps : int = 0

func _physics_process(delta):
	player_falling(delta)
	player_move(delta)
	player_jump(delta)
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
		if movement_direction() > 0:
			player_sprite.flip_h = false
		else:
			player_sprite.flip_h = true
			
func player_jump(delta):
	if is_on_floor():
		current_jumps = 0
	
	if Input.is_action_just_pressed("jump") and current_jumps < max_jumps:
		velocity.y = jumpForce
		current_jumps = current_jumps + 1
	
func movement_direction():
	var direction = Input.get_axis("move_left", "move_right")
	return direction
