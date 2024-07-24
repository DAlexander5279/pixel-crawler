extends StaticBody2D

signal isClosed
var door_opened = false

func _physics_process(delta):
	print(BossManager.secondBossDied)
	if BossManager.secondBossDied == true:
		_on_boss_died()

func _on_boss_2_trigger_body_entered(body):
	if door_opened:
		return
	door_opened = true
	$AnimationPlayer.play("Active")
	await get_tree().create_timer(1.3).timeout
	$AnimationPlayer.play("Closed")
	emit_signal("isClosed")


func _on_boss_died():
	queue_free()

func open_door():
	$AnimationPlayer.play("Idle")
