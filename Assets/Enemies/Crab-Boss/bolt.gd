extends Node2D


@onready var sprite = $"AnimatedSprite2D"

var direction = 1
@export var speed = 600
@export var damage = 1

func _physics_process(delta):
	move_local_x(direction * speed * delta)



func _on_hitbox_area_entered(area):
	impact()


func _on_hitbox_body_entered(body):
	impact()
	

func impact():
	queue_free()
