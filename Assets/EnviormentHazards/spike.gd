extends  CharacterBody2D

@export var gravityForce : int = 1000
@export var SPEED : int = 3000


var timerStart = false
@onready var destroyTimer : Timer = $destroyTimer
@export var timerDurcation : float


func _physics_process(delta):
	move_and_slide()
	if BossManager.spikeFall == true:
		velocity.y += gravityForce * delta
		if timerStart == false:
			timerStart = true
			destroyTimer.start(timerDurcation)
			



func _on_destroy_timer_timeout():
	queue_free()
