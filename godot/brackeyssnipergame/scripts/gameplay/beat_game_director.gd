extends Node

@export var food_throwing_npcs: Node3D

@export var cameraController: CameraController

@export var ratController: RatController

@export var beatGameController: BeatGameController

@export var hud: BeatGameHUD

@export var timer: Timer

@export var songConfig: SongConfig

var playing := false
var beatErrors = 0
var beatHits = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = 10
	timer.start()
	_play_rat_intro()
	
func _begin_game():
	#cut camera to stage:
	cameraController.switch_to_stage_view()

func _play_rat_intro():
	ratController.playTalkingAnimation()
	
func _beat_error():
	beatErrors += 1
	hud.UpdateErrors(beatErrors)
	_throw_food()
	
func _throw_food():
	for npc in food_throwing_npcs.get_children():
		if npc.has_method("throw_random_food_at_player"):
			npc.throw_random_food_at_player()

func _on_timer_timeout() -> void:
	hud.disable_dialoge()
	_begin_game()

func _on_rhythm_game_note_incorrect() -> void:
	if playing:
		_beat_error()

func _on_rhythm_game_note_missed() -> void:
	if playing:
		_beat_error()

func _on_rhythm_game_note_random() -> void:
	if playing:
		_beat_error()

func _on_rhythm_game_note_hit() -> void:
	if !playing:
		return
	beatHits += 1
	hud.UpdateCorrectNotes(beatHits)

func _on_rhythm_game_game_finished() -> void:
	playing = false
	cameraController.switch_to_rat_view()

func _on_camera_control_setup_transition_finished(position: String) -> void:
	if position == "stage":
		beatGameController.init(songConfig)
		beatGameController.start_game()
		playing = true
	if position == "rat":
		beatGameController.visible = false
		hud.show_menu_button()
