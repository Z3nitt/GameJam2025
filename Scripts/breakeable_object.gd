extends StaticBody2D

var health_pickup_scene = preload("res://Scenes/health_pickup.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "BulletHitbox":
		print("BLOQUE ROTO")
		
		call_deferred("_spawn_health_pickup")
		
		call_deferred("queue_free")

func _spawn_health_pickup():
	if health_pickup_scene:
		var health_pickup_instance = health_pickup_scene.instantiate()
		health_pickup_instance.position = self.global_position
		get_parent().add_child(health_pickup_instance)
	else:
		print("La escena del health pickup no está asignada")
