extends CharacterBody2D

#sprite reference
@onready var sprite = $AnimatedSprite2D
var deathEffect = preload("res://Assets/Enemies/Animation/death_effect.tscn")
#movement variables
@export var gravityForce : int = 1000
@export var SPEED : int = 3000
var direction : Vector2 = Vector2.LEFT 



#raycast variables
@onready var ledgeCheckleft = $LedgeCheckLeft
@onready var ledgeCheckRight = $LedgeCheckRight


#Health and damage
@export var health = 5

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
	
	
	
	
func checkCollisions():
	var found_wall = is_on_wall()
	var found_ledge = not ledgeCheckleft.is_colliding() or not ledgeCheckRight.is_colliding()
	if found_wall or found_ledge:
		direction.x *= -1
	sprite.flip_h = direction.x > 0
	
func applyGravity(delta):
	if !is_on_floor():
		velocity.y += gravityForce * delta

func idleing(delta):
	current_state = State.Idle
	velocity.x = move_toward(velocity.x, 0, SPEED * delta)
	
func walking(delta):
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
			queue_free()
