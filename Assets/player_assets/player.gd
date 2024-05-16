extends CharacterBody2D
#reference to sprite
@onready var player_sprite = $"AnimatedSprite2D"

#all damange references and variables
var playerDeathEffect = preload("res://Assets/player_assets/Animations/player_death_effect.tscn")
var isDead = false
@onready var invincibleTimer : Timer = $invicibilityTimer
var isInvincible
@onready var hurtbox : CollisionShape2D = $Hitbox/hitCollider
@onready var flashPlayer : AnimationPlayer = $hitFlashPlayer
var isShooting = false
@onready var shootTimer : Timer = $shootTimer
#audio references
@onready var gunSoundEff = $primaryGunSound
@onready var jumpSound = $jumpSound
@onready var deathSound = $deathSound
@onready var hurtSound = $hurtSound

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


var lastDirection = 1


#State machine variables
enum State{Idle, Running, Jump, Shooting, StandShooting}
var current_state : State 

#calls on start
func _ready():
	current_state = State.Idle
	projectile_spawn_point = bulletMarker.position
	


#controls all physics processes
func _physics_process(delta):
	move_and_slide()
	if(isDead == false):
		player_falling(delta)
		player_idle(delta)
		player_move(delta)
		player_jump(delta)
		flip_projectile_position()
		shoot(delta)
		play_animations()







func flip_projectile_position():
	var direction = movement_direction()
	if direction > 0:
		bulletMarker.position.x = projectile_spawn_point.x
		lastDirection = 1
	elif direction < 0:
		bulletMarker.position.x = -projectile_spawn_point.x
		lastDirection = -1

func shoot(delta):
	var direction = movement_direction()
	if direction and Input.is_action_just_pressed("PrimaryFire"):
		current_state = State.Shooting
		gunSoundEff.play()
		var primary_proj = PrimaryProjectile.instantiate() as Node2D
		#adds bullet as a child to the level
		primary_proj.global_position = bulletMarker.global_position
		primary_proj.direction = direction
		get_parent().add_child(primary_proj)
		
	if direction == 0 and Input.is_action_just_pressed("PrimaryFire") and is_on_floor():
		isShooting = true
		shootTimer.start()
		current_state = State.StandShooting
		gunSoundEff.play()
		var primary_proj = PrimaryProjectile.instantiate() as Node2D
		#adds bullet as a child to the level
		primary_proj.global_position = bulletMarker.global_position
		primary_proj.direction = lastDirection
		get_parent().add_child(primary_proj)
		
		
		

#pushes player down by a force
func player_falling(delta):
	if !is_on_floor():
		velocity.y += gravityForce * delta
		
func player_idle(delta):
	if is_on_floor() and !isShooting:
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
		jumpSound.play()
		velocity.y = jumpForce * delta
		current_jumps = current_jumps + 1
		current_state = State.Jump
	
#state machine for player animations
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
		State.StandShooting:
			player_sprite.play("shoot")
			
#returns variable based on input direction
func movement_direction():
	
	var direction = Input.get_axis("move_left", "move_right")
	return direction
#disables physics processes and instantiates effect
func playerDeath():
	velocity.x = 0
	velocity.y = 0
	deathSound.play()
	var effectInstance = playerDeathEffect.instantiate() as Node2D
	effectInstance.global_position = global_position
	get_parent().add_child(effectInstance)
	isDead = true
	visible = false


#calls once player collides with body, check if body is enemy
func _on_hitbox_body_entered(body : Node2D):
	if body.is_in_group("Enemies") and !isInvincible:
		HealthManager.decrease_health(1)
		if(HealthManager.current_health > 0):
			hurtSound.play()
			flashPlayer.play("hitFlash")
			isInvincible = true
			hurtbox.disabled = true
			invincibleTimer.start(1)
	if HealthManager.current_health == 0 and isDead == false:
		playerDeath()
		


func _on_invicibility_timer_timeout():
	hurtbox.disabled = false
	isInvincible = false


func _on_shoot_timer_timeout():
	isShooting = false # Replace with function body.
