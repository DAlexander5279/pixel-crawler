extends Area2D

@onready var door = $"../Door"
@onready var default_game_music = $"../DefaultGameMusic" as AudioStreamPlayer
@onready var boss_fight_1 = $"../BossFight1" as AudioStreamPlayer

func _ready():
	# Connect the body_entered signal to the _on_body_entered function using Callable, if not already connected
	if not is_connected("body_entered", Callable(self, "_on_body_entered")):
		self.connect("body_entered", Callable(self, "_on_body_entered"))


# Function called when a body enters the area
func _on_body_entered(body: Node):
	# Check if the body is the player
	if body.is_in_group("Player"):
		# Call the close_door function
		close_door()
		default_game_music.stop()
		boss_fight_1.play()

func close_door():
	# Assuming the door node has an animation or method to close itself
	if door.has_method("close"):
		door.call("close")
