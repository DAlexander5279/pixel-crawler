extends CharacterBody2D

#sprite reference
@onready var sprite = $AnimatedSprite2D
var deathEffect = preload("res://Assets/Enemies/Animation/death_effect.tscn")
#movement variables
@export var gravityForce : int = 1000
@export var SPEED : int = 3000
var direction : Vector2 = Vector2.LEFT 

@onready var bulletMarker : Marker2D = $Marker2D
var projectile_spawn_point
var PrimaryProjectile = preload("res://Assets/Enemies/Sentinel/sentinelMissle.tscn")

#raycast variables
@onready var ledgeCheckleft = $LedgeCheckLeft
@onready var ledgeCheckRight = $LedgeCheckRight
@export var dir : int = 1

#Health and damage
@export var health = 5

signal boss_died

enum State {Idle, Walk}
var current_state : State

func _ready():
	current_state = State.Idle
	if dir == 1:
		sprite.flip_h = true
		bulletMarker.position.x *= -1
	else:
		dir = -1
	projectile_spawn_point = bulletMarker.position


func _physics_process(delta):
	applyGravity(delta)
	idleing(delta)
	move_and_slide()
	fireWeapon()
	
	
@onready var cdTimer : Timer = $cooldown
var bulletCooldown = false
@export var time : int
func fireWeapon():
	if bulletCooldown == false:
		cdTimer.start(time)
		bulletCooldown = true
		var primary_proj = PrimaryProjectile.instantiate() as Node2D
		#adds bullet as a child to the level
		primary_proj.global_position = bulletMarker.global_position
		primary_proj.direction = dir
		get_parent().add_child(primary_proj)
	
func applyGravity(delta):
	if !is_on_floor():
		velocity.y += gravityForce * delta

func idleing(delta):
	current_state = State.Idle
	velocity.x = move_toward(velocity.x, 0, SPEED * delta)
	


func _on_hitbox_area_entered(area : Area2D):
	if(area.get_parent().has_method("get_damage")):
		var bullet = area.get_parent() as Node
		health -= bullet.damage
		if(health <= 0):
			var deatheffectInstance = deathEffect.instantiate() as Node2D
			deatheffectInstance.global_position = global_position 
			get_parent().add_child(deatheffectInstance)
			queue_free()


func _on_cooldown_timeout():
	bulletCooldown = false
