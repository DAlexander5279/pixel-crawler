extends Area2D

signal PlayerEntered

@onready var default_game_music = $"../DefaultGameMusic" as AudioStreamPlayer
@onready var boss_fight_1 = $"../BossFight1" as AudioStreamPlayer
@onready var boss = $"../Crab2"
@onready var door = $"../Door"

var activated = false

#function to see when player enters trigger space
func _physics_process(delta):
	if activated:
		return
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "player":
			emit_signal("PlayerEntered")
			activated = true
			queue_free()

func _ready():
	connect("PlayerEntered", Callable(self, "_on_PlayerEntered"))
	if boss:
		boss.connect("boss_died", Callable(door, "_on_boss_died"))

func _on_PlayerEntered() -> void:
	default_game_music.stop()
	boss_fight_1.play()
