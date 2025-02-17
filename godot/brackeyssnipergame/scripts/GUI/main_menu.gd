extends Control
@export var credit_menu_node: Control
@export var options_menu_node: Control
@export var main_menu_node: Control

func _on_play_button_pressed() -> void:
	GameManager.start_game()


func _on_options_button_pressed() -> void:
	main_menu_node.visible = false
	options_menu_node.visible = true


func _on_credits_button_pressed() -> void:
	main_menu_node.visible = false
	credit_menu_node.visible = true


func _on_credits_credits_back_button_pressed() -> void:
	main_menu_node.visible = true
	credit_menu_node.visible = false


func _on_options_options_back_button_pressed() -> void:
	main_menu_node.visible = true
	options_menu_node.visible = false
