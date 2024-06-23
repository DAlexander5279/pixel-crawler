extends Node2D


@onready var sprite = $"AnimatedSprite2D"

var direction 
@export var speed = 300
@export var damage = 1

func _physics_process(delta):
	move_local_x(direction * speed * delta)
	flipSprite()




func flipSprite():
	if direction > 0:
			sprite.flip_h = false
	else:
			sprite.flip_h = true

func _on_area_2d_area_entered(area):
	impact()

func _on_area_2d_body_entered(body):
	impact()


	

func impact():
	queue_free()



