extends CharacterBody2D

var enemy_death_effect = preload("res://Scenes/enemy_death_effect.tscn")

var bullet = preload("res://Scenes/bullet_caballito.tscn")

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


const GRAVITY = 1000

enum State {Idle, Walk, Shoot }

var current_state : State
var direction : Vector2 = Vector2.LEFT
var number_of_points: int
var point_positions : Array[Vector2]
var current_point: Vector2
var current_point_position: int
var can_walk : bool
var player_detected: bool = false



func _ready():
	if patrol_points !=null:
		number_of_points = patrol_points.get_children().size()
		for point in patrol_points.get_children():
			point_positions.append(point.global_position)
		current_point = point_positions[current_point_position]
	else:
		print("No hay puntos")
	
	timer.wait_time = wait_time
	shoot_timer.wait_time = shoot_interval
	
	current_state = State.Idle


func _physics_process(delta: float):
	enemy_gravity(delta)
	if player_detected:
		enemy_shoot(delta)
	else:
		enemy_idle(delta)
		enemy_walk(delta)
		
	#enemy_idle(delta)
	#enemy_walk(delta)
	
	move_and_slide()
	
	enemy_animations()

func enemy_gravity(delta):
	velocity.y += GRAVITY * delta

func enemy_idle(delta):
	if !can_walk:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
		current_state = State.Idle

func enemy_walk(delta):
	if !can_walk:
		return
	
	if abs(position.x - current_point.x) > 0.5:
		velocity.x = direction.x * speed * delta
		current_state = State.Walk
	else:
		current_point_position += 1

		if current_point_position >= number_of_points:
			current_point_position = 0

		current_point = point_positions[current_point_position]

		if current_point.x > position.x:
			direction = Vector2.RIGHT
		else:
			direction = Vector2.LEFT
		
		can_walk = false
		timer.start()
	
	animated_sprite_2d.flip_h = direction.x > 0

func enemy_shoot(delta):
	if !shoot_timer.is_stopped():
		return

	shoot_timer.start()
	current_state = State.Shoot
	
	var bullet_instance = bullet.instantiate() as Node2D
	bullet_instance.global_position = position + Vector2(direction.x * 10, 0)  # Ajusta el offset
	bullet_instance.direction = direction.x  # Asegúrate de que las balas disparen en la dirección correcta
	get_parent().add_child(bullet_instance)

func enemy_animations():
	if current_state == State.Idle and !can_walk:
		animated_sprite_2d.play("Idle")
	elif current_state == State.Shoot:
		animated_sprite_2d.play("Shoot")

func _on_timer_timeout() -> void:
	can_walk = true


func _on_hurtbox_area_entered(area: Area2D):
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
	


func _on_animated_sprite_2d_animation_finished() -> void:
	pass # Replace with function body.


func _on_detection_player_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_detected = true
		shoot_timer.start()


func _on_shoot_timer_timeout() -> void:
	pass # Replace with function body.


func _on_detection_player_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_detected = false
		shoot_timer.stop()
		current_state = State.Idle
