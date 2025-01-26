extends CharacterBody2D

var enemy_death_effect = preload("res://Scenes/enemy_death_effect.tscn")

var Bullet = preload("res://Scenes/bullet_caballito.tscn")



@onready var muzzle = $Muzzle

var canshoot = true
var player = null

@export var patrol_points : Node
@export var speed : int = 1500
@export var wait_time : int = 3
@export var health_amount : int = 3
@export var damage_amount : int = 1
@export var shoot_interval: float = 2.0

@onready var detection_zone = $DetectionPlayer
@onready var shoot_timer = $ShootTimer
@onready var animated_sprite_2d = $AnimatedSprite2D

@onready var timer = $Timer

func _ready() -> void:
	animated_sprite_2d.play("Idle")

func _on_detection_player_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body

func _physics_process(delta: float) -> void:
	pass


func _on_shoot_timer_timeout() -> void:
	canshoot = true
	if player != null:
		shoot()

func shoot():
	if canshoot:
		animated_sprite_2d.play("Shoot")
		var bullet = Bullet.instantiate()
		bullet.position = muzzle.global_position
		bullet.direction = sign(player.global_position.x - global_position.x)
		get_parent().add_child(bullet)
		
		$ShootTimer.start()
		canshoot = false
		animated_sprite_2d.play("Idle")

func _on_timer_timeout() -> void:
	pass # Replace with function body.


func _on_animated_sprite_2d_animation_finished() -> void:
	pass # Replace with function body.


func _on_hurtbox_area_entered(area: Area2D) -> void:
	print("Hurtbox")
	if area.get_parent().has_method("get_damage_amount"):
		var node = area.get_parent() as Node
		health_amount -= node.damage_amount
		print("Vida", health_amount)
		
	if health_amount <=0:
		var enemy_death_effect_instance = enemy_death_effect.instantiate() as Node2D
		enemy_death_effect_instance.global_position = global_position
		get_parent().add_child(enemy_death_effect_instance)
		GameManager.score_points += 100
		queue_free()
