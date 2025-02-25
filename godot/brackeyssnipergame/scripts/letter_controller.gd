extends Node2D
class_name LetterController

@export var letter_label : Label

@export var note_missed : ColorRect
@export var note_correct : ColorRect

var cached_letter : String = ''
var context_info : Variant

@export var sprite: Sprite2D

var missed := false
var hit := false

func get_context() -> Variant:
	return context_info

func get_letter() -> String:
	return cached_letter

func notify_hit():
	note_correct.visible = true
	fly_up()

func notify_missed():
	fade_out()

func notify_wrong_note():
	note_missed.visible = true
	fall_down()
	
func fade_out():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + Vector2(-200, 0), 0.4).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(sprite, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(queue_free)  # Free after animation

func fly_up():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + Vector2(-200, -600), 0.4).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(queue_free)  # Free after animation

func fall_down():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + Vector2(-200, 600), 0.4).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(queue_free)  # Free after animation

func set_info(letter : String, context : Variant):
	context_info = context
	cached_letter = letter
	letter_label.text = letter
