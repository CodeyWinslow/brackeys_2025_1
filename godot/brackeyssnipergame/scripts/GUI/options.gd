extends Control

signal options_back_button_pressed

func _on_back_button_pressed() -> void:
	options_back_button_pressed.emit()
