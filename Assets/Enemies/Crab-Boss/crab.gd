extends CharacterBody2D

#sprite reference
@onready var sprite = $AnimatedSprite2D
@onready var pauseTimer : Timer = $pauseTimer
@onready var bufferTimer : Timer = $bufferTimer

var deathEffect = preload("res://Assets/Enemies/Animation/death_effect.tscn")
#movement variables
@export var gravityForce : int = 1000
@export var SPEED : int = 3000
var direction : Vector2 = Vector2.LEFT 

var pauseAndShoot = false

#raycast variables
@onready var ledgeCheckleft = $LedgeCheckLeft
@onready var ledgeCheckRight = $LedgeCheckRight


#Health and damage
@export var health = 5

signal boss_died

enum State {Idle, Walk}
var current_state : State

func _ready():
	current_state = State.Idle


func _physics_process(delta):
	checkCollisions()
	applyGravity(delta)
	idleing(delta)
	walking(delta)
	move_and_slide()
	play_animations()
	
	
	
func checkCollisions():
	var found_wall = is_on_wall()
	var found_ledge = not ledgeCheckleft.is_colliding() or not ledgeCheckRight.is_colliding()
	if found_wall or found_ledge:
		direction.x *= -1
		sprite.flip_h = direction.x > 0
		bufferTimer.start(1)
		
	
	
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


func _on_buffer_timer_timeout():
	pauseAndShoot = true
	pauseTimer.start(5)
