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
var paused : bool = false
var pause_screen_instance : Node = null

func _ready():
	_validate_globals()
	
	stages = global_config.game_config.stages
	
	if not OS.has_feature("editor"):
		if global_config.force_load_shell:
			_load_shell()
		Console.disable()
	else:
		_register_commands()
	
	process_mode = PROCESS_MODE_ALWAYS
	
	# TODO: fixup game flow state if loading into a non-shell scene

func _process(delta):
	if Input.is_action_just_pressed('pause') and game_flow_state == GameFlowState.INGAME:
		set_paused(not paused)

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
	
func quit_to_menu():
	if game_flow_state != GameFlowState.INGAME:
		Logger.print_error('can not quit to menus when out of game')
		return
	
	set_paused(false)
	Logger.print('quitting to menu')
	current_stage = 0
	_load_shell()
	
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
	
func get_gameplay_director() -> GameplayDirector:
	return game_director

func set_paused(is_paused : bool):
	if is_paused != paused:
		if is_paused:
			pause_screen_instance = global_config.pause_scene.instantiate()
			add_child(pause_screen_instance)
		else:
			pause_screen_instance.queue_free()
			pause_screen_instance = null
			
		paused = is_paused
		get_tree().paused = paused

# Console commands
