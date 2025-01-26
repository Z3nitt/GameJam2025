extends CanvasLayer





func _on_continue_button_pressed() -> void:
	GameManager.resume_game()
	queue_free()


func _on_menu_button_pressed() -> void:
	GameManager.main_menu()
	queue_free()


func _on_resume_button_pressed() -> void:
	pass # Replace with function body.
