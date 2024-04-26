extends StaticBody2D


signal isClosed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_trigger_player_entered():
	$AnimationPlayer.play("Active")
	await get_tree().create_timer(1.3)
	$AnimationPlayer.play("Closed")
	emit_signal("isClosed")
