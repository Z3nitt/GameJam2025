extends AnimatedSprite2D

var bullet_impact_effect = preload("res://Scenes/bullet_impact_effect.tscn")

var speed : int = 600
var direction : int
var damage_amount : int = 1

@onready var animated_sprite_2d = $"."

func _ready() -> void:
	animated_sprite_2d.play("Shoot")  # Inicia la animación de la bala, si la tienes configurada

	# Flip de la bala según la dirección
	flip_bullet()

func _process(delta: float) -> void:
	# Mueve la bala según la dirección
	move_local_x(direction * speed * delta)

func _on_timer_timeout() -> void:
	queue_free()  # Elimina la bala después de cierto tiempo

func _on_hitbox_area_entered(area: Area2D) -> void:
	print("Área de la bala")
	bullet_impact()  # Llamar al impacto de la bala

func _on_hitbox_body_entered(body: Node2D) -> void:
	print("Cuerpo de la bala")
	bullet_impact()  # Llamar al impacto de la bala

func get_damage_amount() -> int:
	return damage_amount  # Retorna el daño de la bala

func bullet_impact():
	# Crear el efecto de impacto de la bala
	var bullet_impact_effect_instance = bullet_impact_effect.instantiate() as Node2D
	bullet_impact_effect_instance.global_position = global_position
	get_parent().add_child(bullet_impact_effect_instance)
	queue_free()  # Elimina la bala después del impacto

# Función para flipar la bala según su dirección
func flip_bullet():
	if direction < 0:
		flip_h = true  # Flip horizontal a la izquierda
	else:
		flip_h = false  # No flip, dirección hacia la derecha
