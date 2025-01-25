extends CanvasLayer

func _physics_process(delta):
	resume_game()

func resume_game():
	if Input.is_action_just_pressed("escape"):
		_on_continue_button_pressed()
	
func _on_continue_button_pressed() -> void:
	GameManager.resume_game()
	queue_free()


func _on_menu_button_pressed() -> void:
	GameManager.main_menu()
	queue_free()
