extends Node

var max_health : int  = 3
var current_health : int
var max_jumps : int = 1
var currentJumps : int = 0

signal healt_change

var testSignal = false



func _ready():
	current_health = max_health
	
func activateDoubleJump():
	max_jumps = 2
	
func add_Health(health_amount : int):
	current_health += health_amount
	if(current_health > max_health):
		current_health = max_health
	healt_change.emit(current_health)

func decrease_health(health_amount : int):
	current_health -= health_amount
	if current_health < 0:
		current_health = 0
	healt_change.emit(current_health)
