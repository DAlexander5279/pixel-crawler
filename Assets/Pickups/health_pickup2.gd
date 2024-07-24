
extends Node2D

@onready var soundEff = $powerUpSound
@onready var collider = $Area2D/CollisionShape2D
@onready var sprite = $"Health-red32Px"

var triggered = false


func _on_area_2d_body_entered(body : Node2D):
	if body.is_in_group("Player") and triggered == false:
		triggered = true
		HealthManager.add_Health(1)
		collider.disabled = true
		sprite.visible = false
		soundEff.play()


func _on_power_up_sound_finished():
	queue_free()
