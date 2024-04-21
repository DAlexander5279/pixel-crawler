extends AnimatedSprite2D

var bulletEffect  = preload("res://Assets/player_assets/projectiles/impact_effect.tscn")

var direction
@export var speed = 600

func _physics_process(delta):
	move_local_x(direction * speed * delta)

func _on_timer_timeout():
	queue_free()


func _on_hitbox_area_entered(area):
	impact()


func _on_hitbox_body_entered(body):
	impact()
	
	
func impact():
	var bulletEffect_spawn = bulletEffect.instantiate() as Node2D
	bulletEffect_spawn.global_position = global_position
	get_parent().add_child(bulletEffect_spawn)
	queue_free()
