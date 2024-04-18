extends CharacterBody2D

#sprite reference
@onready var sprite = $AnimatedSprite2D

#movement variables
@export var gravityForce : int = 1000
@export var SPEED : int = 3000
var direction : Vector2 = Vector2.LEFT 

#raycast variables
@onready var ledgeCheckleft = $LedgeCheckLeft
@onready var ledgeCheckRight = $LedgeCheckRight


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
	
