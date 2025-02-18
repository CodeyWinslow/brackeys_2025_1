extends Control

func _on_exit_button_pressed() -> void:
	GameManager.quit_to_menu()


func _on_resume_button_pressed() -> void:
	# We will need to call game's unpause logic
	pass
