extends Node2D



@onready var heart1 = $Sprite2D
@onready var heart2 = $Sprite2D2
@onready var heart3 = $Sprite2D3


func _ready():
	HealthManager.healt_change.connect(player_health_change)
	
	
func player_health_change(health : int):
	print(health)
	if health == 3:
		heart3.play("default")
	elif health < 3:
		heart3.play("off")
		
		
	if health >= 2:
		heart2.play("default")
	elif health < 2:
		heart2.play("off")
		
		
	if health >= 1:
		heart1.play("default")
	elif health < 1:
		heart1.play("off")
