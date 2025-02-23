extends Node

enum GameFlowState
{
	SHELL,
	INGAME
}

var global_config : GameManagerGlobals = preload("res://resources/release_game_manager_globals.tres")
var game_flow_state : GameFlowState = GameFlowState.SHELL

var stages : Array[PackedScene]
var current_stage = 0

var game_director : GameplayDirector = null
var music_director : MusicDirector = null
var ui_layer : CanvasLayer
var paused : bool = false
var pause_screen_instance : Node = null

var debug_mouse_released = false
var is_editor = false

func _ready():
	_validate_globals()
	
	stages = global_config.game_config.stages
	
	is_editor = OS.has_feature("editor")
	if not is_editor:
		if global_config.force_load_shell:
			_load_shell()
		Console.disable()
	else:
		_register_commands()
	
	process_mode = PROCESS_MODE_ALWAYS
	
	_update_mouse_mode()
	
	ui_layer = CanvasLayer.new()
	ui_layer.layer = 2
	add_child(ui_layer)
	
	# TODO: fixup game flow state if loading into a non-shell scene

func _process(_delta):
	if Input.is_action_just_pressed('pause') and game_flow_state == GameFlowState.INGAME:
		set_paused(not paused)
	if Input.is_action_just_pressed('debug_toggle_mouse') and is_editor:
		debug_mouse_released = not debug_mouse_released
		_update_mouse_mode()

func _validate_globals():
	var has_failure = false
	if global_config == null:
		Logger.print_error('No Game Manager Globals loaded.')
		has_failure = true
	
	if not has_failure and global_config.shell_scene == null:
		Logger.print_error('No shell scene defined in Game Manager Globals.')
		has_failure = true
	
	if has_failure:
		get_tree().quit()

func _update_mouse_mode():
	var mouse_mode = Input.MOUSE_MODE_VISIBLE
	if game_flow_state == GameFlowState.INGAME and not paused and not debug_mouse_released:
		mouse_mode = Input.MOUSE_MODE_CAPTURED
	Input.set_mouse_mode(mouse_mode)

func _register_commands():
	Console.add_command('gameflow.start', start_game, [], 0, 'force start da game')
	Console.add_command('gameflow.quit', quit_to_menu, [], 0, 'quit to main menu')
	Console.add_command('gameflow.nextstage', proceed_stage, [], 0, 'force to next stage')

func _load_shell():
	game_flow_state = GameFlowState.SHELL
	var scene : PackedScene = global_config.shell_scene
	get_tree().change_scene_to_packed(scene)

# Game Flow API

func start_game():
	if game_flow_state != GameFlowState.SHELL:
		Logger.print_error('could not start game. application is not in menus')
		return
	
	Logger.print('starting game!')
	_load_current_stage()
	_update_mouse_mode()
	
func quit_to_menu():
	if game_flow_state != GameFlowState.INGAME:
		Logger.print_error('can not quit to menus when out of game')
		return
	
	set_paused(false)
	Logger.print('quitting to menu')
	current_stage = 0
	_load_shell()
	_update_mouse_mode()
	
func proceed_stage():
	if game_flow_state != GameFlowState.INGAME:
		Logger.print_error('can not proceed stages when out of game')
		return
	
	var next_stage = current_stage + 1
	if next_stage >= len(stages):
		Logger.print('finished all stages')
	else:
		current_stage = next_stage
		_load_current_stage()

func _load_current_stage():
	game_flow_state = GameFlowState.INGAME
	var stage_scene : PackedScene = stages[current_stage]
	get_tree().change_scene_to_packed(stage_scene)

# Gameplay API

func register_gameplay_director(director : GameplayDirector):
	if game_director != null:
		Logger.print_error('tried registering a GameplayDirector while one is already registered')
		return
		
	game_director = director
	
func unregister_gameplay_director(director : GameplayDirector):
	if game_director != director:
		Logger.print_error('tried unregistering a GameplayDirector while it wasn\'t registered')
		return
		
	game_director = null

func register_music_director(director : MusicDirector):
	if game_director != null:
		Logger.print_error('tried registering a MusicDirector while one is already registered')
		return
		
	music_director = director
	
func unregister_music_director(director : MusicDirector):
	if game_director != director:
		Logger.print_error('tried unregistering a MusicDirector while it wasn\'t registered')
		return
		
	music_director = null

func get_gameplay_director() -> GameplayDirector:
	return game_director

func set_paused(is_paused : bool):
	if is_paused != paused:
		if is_paused:
			pause_screen_instance = global_config.pause_scene.instantiate()
			if pause_screen_instance is Control:
				var ctrl = pause_screen_instance as Control
				ctrl.z_index = 100
			ui_layer.add_child(pause_screen_instance)
		else:
			pause_screen_instance.queue_free()
			pause_screen_instance = null
			
		paused = is_paused
		get_tree().paused = paused
		_update_mouse_mode()

# Console commands
