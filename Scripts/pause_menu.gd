extends CanvasLayer





func _on_continue_button_pressed() -> void:
	GameManager.resume_game()
	queue_free()


func _on_menu_button_pressed() -> void:
	GameManager.main_menu()
	queue_free()
