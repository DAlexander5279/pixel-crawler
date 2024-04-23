extends Area2D

signal PlayerEntered

#function to see when player enters trigger space
func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			emit_signal("PlayerEntered")
			queue_free()

func _ready():
	pass # Replace with function body.
