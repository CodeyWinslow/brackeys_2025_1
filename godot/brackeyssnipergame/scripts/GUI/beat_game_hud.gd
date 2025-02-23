class_name BeatGameHUD

extends Control

@export var errorsLabel: RichTextLabel
@export var correctLabel: RichTextLabel
@export var missesLabel: RichTextLabel
@export var score_labels: VBoxContainer

@export var dialog: Control
@export var menu_button: Control
@export var summary: Control
@export var accuracy_label: Label
@export var grade_label: Label

func UpdateErrors(errors):
	errorsLabel.text = "Errors: " + str(errors)
	
func UpdateCorrectNotes(correct):
	correctLabel.text = "Correct: " + str(correct)
	
func UpdateBlunders(blunders):
	missesLabel.text = "Blunders: " + str(blunders)

func disable_dialoge():
	dialog.visible = false
	
func show_menu_button():
	menu_button.visible = true

func hide_score_labels():
	score_labels.visible = false

func show_summary_view(accuracy: int):
	var letter_grade = ""
	if accuracy >= 90:
		if accuracy >= 97:
			letter_grade = "A+"
		else:
			letter_grade = "A"
	elif accuracy >= 87:
		letter_grade = "A-"
	elif accuracy >= 80:
		if accuracy >= 84:
			letter_grade = "B+"
		else:
			letter_grade = "B"
	elif accuracy >= 77:
		letter_grade = "B-"
	elif accuracy >= 70:
		if accuracy >= 74:
			letter_grade = "C+"
		else:
			letter_grade = "C"
	elif accuracy >= 67:
		letter_grade = "C-"
	elif accuracy >= 60:
		if accuracy >= 64:
			letter_grade = "D+"
		else:
			letter_grade = "D"
	elif accuracy >= 50:
		letter_grade = "D-"
	else:
		letter_grade = "F"

	accuracy_label.text = "Accuracy: %s" % accuracy
	grade_label.text = letter_grade
	summary.visible = true

func _on_menu_pressed() -> void:
	GameManager.quit_to_menu()
