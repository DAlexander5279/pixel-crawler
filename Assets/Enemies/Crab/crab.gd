extends CharacterBody2D
@export var gravityForce : int = 1000
@export var SPEED : int = 3000
var direction : Vector2 = Vector2.LEFT 

enum State {Idle, Walk}
var current_state : State

func _ready():
	current_state = State.Idle


func _physics_process(delta):
	applyGravity(delta)
	idleing(delta)
	walking(delta)
	move_and_slide()
	
	
	
func applyGravity(delta):
	if !is_on_floor():
		velocity.y += gravityForce * delta

func idleing(delta):
	current_state = State.Idle
	velocity.x = move_toward(velocity.x, 0, SPEED * delta)
	
func walking(delta):
	current_state = State.Walk
	velocity.x = direction.x * SPEED * delta
