extends CharacterBody2D


@export var health = 90

@onready var base_sprite = $"Mech/upperBoddy/Marker2D/SpriteTorso"
@onready var phaseTimer : Timer = $phaseTimer
@onready var phase_player = $"AnimationPlayer"
var isAttacking = false

func _ready():
	randomize()

func _physics_process(delta):
	checkHealth()
	attackPhase()
	
func attackPhase():
	
	if !isAttacking:
		var random_number = randi() % 3 + 1
		print(random_number)
		isAttacking = true
		print("entered")
		match random_number:
			1:
				phase_player.play("fist_smash")
				print("entered phase")
				phaseTimer.start(2)
			2:
				phase_player.play("laser")
				phaseTimer.start(3.9)
				print("entered phase")
			3:
				phase_player.play("ground smash")
				phaseTimer.start(4.1)
				print("entered phase")
		
	
func checkHealth():
	if health < 30:
		base_sprite.play(("LowHealth"))
	elif  health < 60:
		base_sprite.play("MidHealth")
	else:
		base_sprite.play("FullHealth")
		



		
		
		
	
var idle = false

func _on_phase_timer_timeout():
	if idle == false:
		idle = true
		phase_player.play("idling")
		phaseTimer.start(1)
	else:
		isAttacking = false
		idle = false


func _on_hit_box_area_entered(area):
	if(area.get_parent().has_method("get_damage")):
		var bullet = area.get_parent() as Node
		health -= bullet.damage
		if(health <= 0):
			BossManager.secondBossDied = true
			queue_free()
