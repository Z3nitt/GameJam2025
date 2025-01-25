extends CharacterBody2D
# Carga la bala en la anim
var bullet = preload("res://Scenes/bullet.tscn")

var player_death_effect = preload("res://Scenes/player_death_effect.tscn")

# Instanciar animación
@onready var animated_sprite_2d = $AnimatedSprite2D

@onready var hit_animation_player = $HitAnimationPlayer
# Instacia el puntero
@onready var muzzle = $Muzzle

# Gravedad, velocidad y salto
const GRAVITY = 1000
const SPEED = 200
const JUMP = -300
const AIR_CONTROL = 150  # Control horizontal en el aire

# Enumeración de los estados
enum State { Idle, Run, Jump, Shoot, Hurt }

var current_state

var muzzle_position

var is_shooting = false

# Empieza en Idle
func _ready():
	current_state = State.Idle
	muzzle_position = muzzle.position

# Métodos que puede ejecutar el player
func _physics_process(delta):
	apply_gravity(delta)
	handle_movement(delta)
	handle_jump(delta)
	
	player_muzzle_position()
	
	player_shooting(delta)
	
	move_and_slide()
	
	update_animation()
	
# Aplicar gravedad
func apply_gravity(delta):
	if !is_on_floor():
		velocity.y += GRAVITY * delta

# Manejar movimiento horizontal
func handle_movement(delta):
	var direction = Input.get_axis("move_left", "move_right")

	if is_on_floor():
		# Movimiento completo cuando está en el suelo
		velocity.x = direction * SPEED
		if direction != 0:
			current_state = State.Run
			animated_sprite_2d.flip_h = direction < 0
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			current_state = State.Idle
	else:
		# Movimiento más sensible en el aire
		if direction != 0:
			velocity.x = lerp(velocity.x, direction * SPEED, 0.1)  # Ajuste más suave
			animated_sprite_2d.flip_h = direction < 0
		else:
			velocity.x = move_toward(velocity.x, 0, AIR_CONTROL * delta)  # Desacelera si no hay input

# Manejar el salto
func handle_jump(delta):
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP
		current_state = State.Jump

func player_shooting(delta):
	if Input.is_action_just_pressed("shoot") and !is_shooting:
		# Determina la dirección basada en flip_h
		var direction = 1 if !animated_sprite_2d.flip_h else -1
		
		# Instancia la bala
		var bullet_instance = bullet.instantiate() as Node2D
		bullet_instance.direction = direction
		bullet_instance.global_position = muzzle.global_position
		get_parent().add_child(bullet_instance)
		
		# Cambia al estado de disparo
		current_state = State.Shoot
		is_shooting = true  # Activa la bandera para bloquear otros disparos
		animated_sprite_2d.play("Shoot")  # Reproduce la animación de dis

# Para que al girar a la izquierda no salga el disparo del sobaco
func player_muzzle_position():
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		muzzle.position.x = muzzle_position.x
	elif direction < 0:
		muzzle.position.x = - muzzle_position.x

# Actualizar animación
func update_animation():
	if is_shooting:
		return  # No cambiar animaciones mientras dispara
	if current_state == State.Idle:
		animated_sprite_2d.play("Idle")
	elif current_state == State.Run:
		animated_sprite_2d.play("Run")
	elif current_state == State.Jump:
		animated_sprite_2d.play("Jump")

func player_death():
	var player_death_effect_instance = player_death_effect.instantiate() as Node2D
	player_death_effect_instance.global_position = global_position
	get_parent().add_child(player_death_effect_instance)
	queue_free()

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "Shoot":
		is_shooting = false  # Permitir otros estados
		current_state = State.Idle  # Regresar al estado predeterminado


func _on_hurtbox_body_entered(body: Node2D):
	if body.is_in_group("Enemy"):
		print("Colision enemigo", body.damage_amount)
		
		hit_animation_player.play("hit")
		HealthMonitor.decrease_health(body.damage_amount)
	if HealthMonitor.current_health == 0:
		player_death()
