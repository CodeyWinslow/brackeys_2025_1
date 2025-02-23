extends Control
@export var credit_menu_node: Control
@export var options_menu_node: Control
@export var main_menu_node: Control
@export var music_selection_node: Control

func _on_play_button_pressed() -> void:
	AudioManager.set_music_playing(false)
	main_menu_node.visible = false
	music_selection_node.visible = true

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


func _on_music_selector_back_button_pressed() -> void:
	AudioManager.set_music_playing(true)
	main_menu_node.visible = true
	music_selection_node.visible = false
