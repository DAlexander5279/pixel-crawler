extends AnimatedSprite2D

var direction
@export var speed = 600

func _physics_process(delta):
	move_local_x(direction * speed * delta)

func _on_timer_timeout():
	queue_free()
