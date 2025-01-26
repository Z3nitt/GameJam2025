extends CanvasLayer



func _on_menu_button_pressed() -> void:
	GameManager.main_menu()
	queue_free()


func _on_exit_button_pressed() -> void:
	GameManager.exit_game()
