extends AnimatedSprite2D

var bullet_caballito_impact_effect = preload("res://Scenes/bullet_caballito_impact.tscn")

var speed : int = 600
var direction : int
var damage_amount : int = 1


func _process(delta: float) -> void:
	move_local_x(direction * speed * delta)


func _on_timer_timeout() -> void:
	queue_free()


func _on_hitbox_area_entered(area: Area2D) -> void:
	print("Area de la bala")
	bullet_impact()


func _on_hitbox_body_entered(body: Node2D) -> void:
	print("Cuerpo de la bala")
	bullet_impact()

func get_damage_amount() -> int:
	return damage_amount

func bullet_impact():
	var bullet_caballito_impact_effect_instance = bullet_caballito_impact_effect.instantiate() as Node2D
	bullet_caballito_impact_effect_instance.global_position = global_position
	get_parent().add_child(bullet_caballito_impact_effect_instance)
	queue_free()
