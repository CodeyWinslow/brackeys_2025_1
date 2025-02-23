class_name BeatGameHUD

extends Control

@export var errorsLabel: RichTextLabel
@export var correctLabel: RichTextLabel

func UpdateErrors(errors):
	errorsLabel.text = "Errors: " + str(errors)
	
func UpdateCorrectNotes(correct):
	correctLabel.text = "Correct: " + str(correct)
