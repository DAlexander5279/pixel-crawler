extends Node2D


var spikeNode = preload("res://Assets/EnviormentHazards/spike.tscn")
@onready var marker : Marker2D = $spawnMarker

var isSpawned = false


func _physics_process(delta):
	if HealthManager.testSignal == true and isSpawned == false:
		isSpawned = true
		var spike = spikeNode.instantiate() as Node2D
		#adds bullet as a child to the level
		spike.global_position = marker.global_position
		get_parent().add_child(spike)
