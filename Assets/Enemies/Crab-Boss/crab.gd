extends CharacterBody2D

#sprite reference
@onready var sprite = $AnimatedSprite2D
@onready var pauseTimer : Timer = $pauseTimer
@onready var bufferTimer : Timer = $bufferTimer



@onready var bulletMarker : Marker2D = $FirePoint
var projectile_spawn_point
var PrimaryProjectile = preload("res://Assets/Enemies/Crab-Boss/bolt.tscn")
var bulletCooldown = false
@onready var coolDownTimer : Timer = $bulletCooldown


var deathEffect = preload("res://Assets/Enemies/Animation/death_effect.tscn")
#movement variables
@export var gravityForce : int = 1000
@export var SPEED : int = 3000
var direction : Vector2 = Vector2.LEFT 

var pauseAndShoot = false
var isFirstCollision = true
#raycast variables
@onready var ledgeCheckleft = $LedgeCheckLeft
@onready var ledgeCheckRight = $LedgeCheckRight


#Health and damage
@export var maxHealth : int
var health : int

signal boss_died

enum State {Idle, Walk, Punch}
enum battleState {Patrol, GroundPound}
var current_battle_state : battleState 
var current_state : State




#variables for ground pound phase
@export var moveCenterTime : float
@onready var centerTimer : Timer = $centerTimer
@onready var spikeFallTimer : Timer = $spikeFallTimer
@onready var punchTimer : Timer = $punchTimer
var spikeWave : int = 1

var isPunching : bool = false #needs to be reset
var centerTimerStarted = false #needs to be reset
var phaseTwoStart = false #needs to be reset
var isCenter = false #needs to be reset
var lastKnownHealth : int


func _ready():
	health = maxHealth
	lastKnownHealth = health
	
	randomize()
	
	current_state = State.Idle
	current_battle_state = battleState.Patrol
	projectile_spawn_point = bulletMarker.position


func _physics_process(delta):
	move_and_slide()
	play_animations()
	applyGravity(delta)
	checkHealth()
	match current_battle_state:
		battleState.Patrol:
			checkCollisions()
			idleing(delta)
			walking(delta)
			fireBullet()
			checkHealth()
		battleState.GroundPound:
			if isCenter == false:
				if centerTimerStarted == false:
					centerTimerStarted = true
					centerTimer.start(moveCenterTime)
				walking(delta)
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED * delta)
				current_state = State.Punch
				punchSequence()
	



var animationStarted = false
var spawnWave = true




func _on_punch_timer_timeout():
	print("TimerFinished")
	
	if spikeWave <= 3 and spawnWave == true:
		BossManager.spikeFall = false
		spawnWave = false
		var random_number = randi() % 5 + 1
		BossManager.currentPattern = random_number
		spikeFallTimer.start(1)
	elif spikeWave > 3:
		#reset phase variables
		current_battle_state = battleState.Patrol
		isCenter = false
		phaseTwoStart = false
		#reset phase 2 variables
		spikeWave = 1
		BossManager.currentPattern = 0
		spawnWave = true
		animationStarted = false
	else:
		BossManager.currentPattern = 0
		BossManager.spikeFall = true
		spawnWave = true
		spikeWave += 1
		spikeFallTimer.start(1)
	


func punchSequence():
	if  animationStarted == false:
		animationStarted = true
		sprite.play("ground_punch")
		punchTimer.start(0.7)
	
func _on_spike_fall_timer_timeout():
	print("Timeout")
	animationStarted = false
	
		





func checkHealth():
	if (lastKnownHealth - (maxHealth / 4)) >= health:
		lastKnownHealth = health
		phaseTwoStart = true
	
func checkCollisions():
	var found_wall = is_on_wall()
	var found_ledge = not ledgeCheckleft.is_colliding() or not ledgeCheckRight.is_colliding()
	if found_wall or found_ledge:
		bulletMarker.position.x *= -1
		direction.x *= -1
		sprite.flip_h = direction.x > 0
		bufferTimer.start(1)
		
	
	
func fireBullet():
	if pauseAndShoot == true and bulletCooldown == false:
		coolDownTimer.start(1)
		bulletCooldown = true
		var primary_proj = PrimaryProjectile.instantiate() as Node2D
		#adds bullet as a child to the level
		primary_proj.global_position = bulletMarker.global_position
		primary_proj.direction = direction.x
		get_parent().add_child(primary_proj)
	
func applyGravity(delta):
	if !is_on_floor():
		velocity.y += gravityForce * delta

func idleing(delta):
	if pauseAndShoot == true:
		current_state = State.Idle
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
	
func walking(delta):
	if pauseAndShoot == false :
		current_state = State.Walk
		velocity.x = direction.x * SPEED * delta
	


func _on_hitbox_area_entered(area : Area2D):
	if(area.get_parent().has_method("get_damage")):
		var bullet = area.get_parent() as Node
		health -= bullet.damage
		if(health <= 0):
			BossManager.bossHasDied = true
			var deatheffectInstance = deathEffect.instantiate() as Node2D
			deatheffectInstance.global_position = global_position 
			get_parent().add_child(deatheffectInstance)
			emit_signal("boss_died") #emit the death signal when boss dies
			queue_free()


func play_animations():
	match current_state:
		State.Idle:
			sprite.play("idle")
		State.Walk:
			sprite.play("walk")
		


func _on_pause_timer_timeout():
	pauseAndShoot = false
	if phaseTwoStart == true:
		current_battle_state = battleState.GroundPound


func _on_buffer_timer_timeout():
	if isFirstCollision == false:
		pauseAndShoot = true
		pauseTimer.start(5)
	isFirstCollision = false


func _on_bullet_cooldown_timeout():
	bulletCooldown = false


func _on_center_timer_timeout():
	isCenter = true
	centerTimerStarted = false





