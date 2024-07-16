extends StaticBody2D

signal isClosed
var door_opened = false

func _on_boss_2_trigger_body_entered(body):
	if door_opened:
		return
	$AnimationPlayer.play("Active")
	await get_tree().create_timer(1.3).timeout
	$AnimationPlayer.play("Closed")
	emit_signal("isClosed")
