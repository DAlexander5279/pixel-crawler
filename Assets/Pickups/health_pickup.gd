extends Node2D







func _on_area_2d_body_entered(body : Node2D):
	if body.is_in_group("Player"):
		HealthManager.add_Health(1)
		queue_free()
