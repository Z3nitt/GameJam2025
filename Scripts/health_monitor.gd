extends Node

var max_health : int= 3
var current_health : int

signal on_health_change

func _ready():
	current_health = max_health


func decrease_health(health_amount : int):
	current_health -= health_amount
	print("-1 de vida")
	
	if current_health < 0:
		current_health = 0
	on_health_change.emit(current_health)

func increase_health(health_amount : int):
	current_health += health_amount
	print("+1 de vida")
	
	if current_health > max_health:
		current_health = max_health
	on_health_change.emit(current_health)
