extends Node2D
class_name LetterController

@export var letter_label : Label

var cached_letter : String = ''
var context_info : Variant

func get_context() -> Variant:
	return context_info

func get_letter() -> String:
	return cached_letter

func notify_hit():
	queue_free()
	
func notify_missed():
	queue_free()
	
func notify_wrong_note():
	queue_free()

func set_info(letter : String, context : Variant):
	context_info = context
	cached_letter = letter
	letter_label.text = letter
