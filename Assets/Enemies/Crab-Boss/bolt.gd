extends Node2D


@onready var sprite = $"AnimatedSprite2D"

@onready var timer : Timer = $destroyTimer
@export var time : int



var direction 
@export var speed = 300
@export var damage = 1

func _ready():
	timer.start(time)

func _physics_process(delta):
	move_local_x(direction * speed * delta)
	flipSprite()




func flipSprite():
	if direction > 0:
			sprite.flip_h = false
	else:
			sprite.flip_h = true





func _on_destroy_timer_timeout():
	queue_free()


