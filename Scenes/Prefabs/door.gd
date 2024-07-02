extends StaticBody2D


signal isClosed
@onready var crab_2 = $"../Crab2" as CharacterBody2D
@onready var default_game_music = $"../DefaultGameMusic" as AudioStreamPlayer
@onready var boss_fight_1 = $"../BossFight1" as AudioStreamPlayer



		
func _physics_process(delta):
	if BossManager.bossHasDied == true:
		_on_boss_died()

var door_opened = false

func _on_trigger_player_entered():
	if door_opened:
		return
	$AnimationPlayer.play("Active")
	await get_tree().create_timer(1.3).timeout
	$AnimationPlayer.play("Closed")
	emit_signal("isClosed")

func _on_boss_died():
	if not door_opened:
		open_door()
		door_opened = true

func open_door():
	$AnimationPlayer.play("Idle")
	default_game_music.play()
	boss_fight_1.stop()
