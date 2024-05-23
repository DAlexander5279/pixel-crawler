extends Area2D

signal PlayerEntered

@onready var main_background_music = $"../Main Background Music" as AudioStreamPlayer
@onready var boss_fight_music = $"../Boss Fight Music" as AudioStreamPlayer


#function to see when player enters trigger space
func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "player":
			emit_signal("PlayerEntered")
			queue_free()

func _ready():
# Connect the PlayerEntered signal to the _on_PlayerEntered function
	connect("PlayerEntered", Callable(self, "_on_PlayerEntered"))

# Function to handle the PlayerEntered signal
func _on_PlayerEntered():
	main_background_music.stop()
	boss_fight_music.play()
