extends Control

signal credits_back_button_pressed

func _on_back_button_pressed() -> void:
	credits_back_button_pressed.emit()
