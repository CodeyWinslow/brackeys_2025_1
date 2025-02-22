extends Node

@export var food_throwing_npcs: Node3D

@export var cameraController: CameraController

@export var ratController: RatController

@export var timer: Timer

var beatErrors = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = 5
	timer.start()
	_play_rat_intro()
	
func _begin_game():
	#cut camera to stage:
	cameraController.switch_to_stage_view()

func _play_rat_intro():
	ratController.playTalkingAnimation()
	
func _beat_error():
	beatErrors += 1
	_throw_food()
	
func _throw_food():
	for npc in food_throwing_npcs.get_children():
		if npc.has_method("throw_food"):
			npc.throw_food()

func _on_timer_timeout() -> void:
	_begin_game()
