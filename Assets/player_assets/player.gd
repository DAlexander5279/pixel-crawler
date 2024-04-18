extends CharacterBody2D
#reference to sprite
@onready var player_sprite = $"AnimatedSprite2D"
#bullet reference
@onready var bulletMarker : Marker2D = $FirePoint
var projectile_spawn_point
var PrimaryProjectile = preload("res://Assets/player_assets/projectiles/projectile_1.tscn")

#variables controlling gravity and movement
@export var gravityForce : int = 1000
@export var playerSpeed : int = 20000
@export var jumpForce : int = -30000
@export var max_jumps : int = 1
@export var current_jumps : int = 0

#health variables
@export var max_health : int = 100
@export var current_health : int = 100

#State machine variables
enum State{Idle, Running, Jump, Shooting}
var current_state : State 

#calls on start
func _ready():
	current_state = State.Idle
	projectile_spawn_point = bulletMarker.position


#controls all physics processes
func _physics_process(delta):
	player_falling(delta)
	player_idle(delta)
	player_move(delta)
	player_jump(delta)
	flip_projectile_position()
	shoot(delta)
	move_and_slide()
	play_animations()



func flip_projectile_position():
	var direction = movement_direction()
	if direction > 0:
		bulletMarker.position.x = projectile_spawn_point.x
	else:
		bulletMarker.position.x = -projectile_spawn_point.x

func shoot(delta):
	var direction = movement_direction()
	if direction and Input.is_action_just_pressed("PrimaryFire"):
		current_state = State.Shooting
		var primary_proj = PrimaryProjectile.instantiate() as Node2D
		#adds bullet as a child to the level
		primary_proj.global_position = bulletMarker.global_position
		primary_proj.direction = direction
		get_parent().add_child(primary_proj)
		
		
#function to take damage : called by enemy projectiles
func player_take_damage(amount):
	current_health = current_health - amount

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
		velocity.x = movement_direction() * playerSpeed * delta
	else:
		velocity.x = move_toward(velocity.x, 0 , playerSpeed * delta)
		
		
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
		velocity.y = jumpForce * delta
		current_jumps = current_jumps + 1
		current_state = State.Jump
	
	
func play_animations():
	match current_state:
		State.Idle:
			player_sprite.play("idle")
		State.Running:
			if player_sprite.animation != "run_shooting":
				player_sprite.play("running")
		State.Jump:
			player_sprite.play("jump")
		State.Shooting:
			player_sprite.play("run_shooting")
#returns variable based on input direction
func movement_direction():
	var direction = Input.get_axis("move_left", "move_right")
	return direction
