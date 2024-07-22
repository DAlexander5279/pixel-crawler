extends Node2D

# Function called when a body enters the exit area
func _on_exit_area_2d_body_entered(body):
	# Check if the body is part of the "Player" group
	if body.is_in_group("Player"):
		# Cast the body to a CharacterBody2D and queue it for deletion
		var player = body as CharacterBody2D
		player.queue_free()

		# Wait for 3 seconds before changing the scene
		await get_tree().create_timer(3.0).timeout
		get_tree().change_scene_to_file("res://Scenes/Main Menu/EndScreen.tscn")

