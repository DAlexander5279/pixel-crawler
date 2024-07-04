extends Node2D


var spikeNode = preload("res://Assets/EnviormentHazards/spike.tscn")
@onready var marker : Marker2D = $spawnMarker

var isSpawned = false

@export var pattern_1 : bool;
@export var pattern_2 : bool;
@export var pattern_3: bool;
@export var pattern_4 : bool;
@export var pattern_5 : bool;




func _physics_process(delta):
	if(BossManager.currentPattern == 0):
		isSpawned = false
	
	if isSpawned == false and BossManager.currentPattern != 0:
		match BossManager.currentPattern:
			1:
				if pattern_1:
					spawnSpike()
			2:
				if pattern_2:
					spawnSpike()
			3:
				if pattern_3:
					spawnSpike()
			4:
				if pattern_4:
					spawnSpike()
			5:
				if pattern_5:
					spawnSpike()
			


func spawnSpike():
	isSpawned = true
	var spike = spikeNode.instantiate() as Node2D
	#adds bullet as a child to the level
	spike.global_position = marker.global_position
	get_parent().add_child(spike)
