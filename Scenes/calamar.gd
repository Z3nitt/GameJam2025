extends CharacterBody2D

var enemy_death_effect = preload("res://Scenes/enemy_death_effect.tscn")

@export var patrol_points : Node
@export var speed : int = 150
@export var wait_time : int = 3
@export var health_amount : int = 4
@export var damage_amount : int = 2

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var timer = $Timer


const GRAVITY = 1000

enum State {Idle}
var current_state : State = State.Idle
var direction : Vector2 = Vector2.UP
var number_of_points: int
var point_positions : Array[Vector2]
var current_point: Vector2
var current_point_position: int
var can_walk : bool




func _ready():
	if patrol_points !=null:
		number_of_points = patrol_points.get_children().size()
		for point in patrol_points.get_children():
			point_positions.append(point.global_position)
		current_point = point_positions[current_point_position]
	else:
		print("No hay puntos")
	
	timer.wait_time = wait_time
	
	current_state = State.Idle
	timer.start()
	animated_sprite_2d.play("Idle")

func _physics_process(delta: float):
	enemy_gravity(delta)
	enemy_walk(delta)
	
	move_and_slide()
	
	enemy_animations()

func enemy_gravity(delta):
	velocity.y += GRAVITY * delta

func enemy_idle(delta):
	if !can_walk:
		velocity.y = move_toward(velocity.y, 0, speed * delta)
		current_state = State.Idle

func enemy_walk(delta):
	if !can_walk:
		return
	
	if abs(position.y - current_point.y) > 0.5:
		velocity.y = direction.y * speed * delta
		current_state = State.Idle
	else:
		current_point_position += 1

		if current_point_position >= number_of_points:
			current_point_position = 0

		current_point = point_positions[current_point_position]

		if current_point.y > position.y:
			direction = Vector2.DOWN
		else:
			direction = Vector2.UP
		
		can_walk = false
		velocity.y = 0
		timer.start()
	

func enemy_animations():
	if current_state == State.Idle && !can_walk:
		animated_sprite_2d.play("Idle")


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


func _on_hurtbox_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
