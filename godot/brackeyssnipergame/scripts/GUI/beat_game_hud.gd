class_name BeatGameHUD

extends Control

@export var errorsLabel: RichTextLabel
@export var correctLabel: RichTextLabel
@export var dialog: Control
@export var menu_button: Control


func UpdateErrors(errors):
	errorsLabel.text = "Errors: " + str(errors)
	
func UpdateCorrectNotes(correct):
	correctLabel.text = "Correct: " + str(correct)

func disable_dialoge():
	dialog.visible = false
	
func show_menu_button():
	menu_button.visible = true

func _on_menu_button_pressed() -> void:
	GameManager.quit_to_menu()
