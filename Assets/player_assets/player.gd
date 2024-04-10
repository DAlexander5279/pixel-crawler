extends CharacterBody2D
#reference to sprite
@onready var player_sprite = $"AnimatedSprite2D"

#variables controlling gravity and movement
@export var gravityForce : int = 1000
@export var playerSpeed : int = 300
@export var jumpForce : int = -300
@export var max_jumps : int = 1
@export var current_jumps : int = 0

#State machine variables
enum State{Idle, Running, Jump}
var current_state : State 

#calls on start
func _ready():
	current_state = State.Idle


#controls all physics processes
func _physics_process(delta):
	player_falling(delta)
	player_idle(delta)
	player_move(delta)
	player_jump(delta)
	move_and_slide()
	play_animations()


#pushes player down by a force
func player_falling(delta):
	if !is_on_floor():
		velocity.y += gravityForce * delta
		
func player_idle(delta):
	if is_on_floor():
		current_state = State.Idle
#moves player based on input direction
func player_move(delta):
	
	if movement_direction():
		velocity.x = movement_direction() * playerSpeed
	else:
		velocity.x = move_toward(velocity.x, 0 , playerSpeed)
		
		
	if movement_direction() != 0:
		if is_on_floor():
			current_state = State.Running
		if movement_direction() > 0:
			player_sprite.flip_h = false
		else:
			player_sprite.flip_h = true
			

#pushes a force upwarard if conditions are met
func player_jump(delta):
	if is_on_floor():
		current_jumps = 0
	
	if Input.is_action_just_pressed("jump") and current_jumps < max_jumps:
		velocity.y = jumpForce
		current_jumps = current_jumps + 1
		current_state = State.Jump
	
	
func play_animations():
	match current_state:
		State.Idle:
			player_sprite.play("idle")
		State.Running:
			player_sprite.play("running")
		State.Jump:
			player_sprite.play("jump")
#returns variable based on input direction
func movement_direction():
	var direction = Input.get_axis("move_left", "move_right")
	return direction
