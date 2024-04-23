extends Node

var max_health : int  = 3
var current_health : int
signal healt_change



func _ready():
	current_health = max_health

func decrease_health(health_amount : int):
	current_health -= health_amount
	if current_health < 0:
		current_health = 0
	healt_change.emit(current_health)
