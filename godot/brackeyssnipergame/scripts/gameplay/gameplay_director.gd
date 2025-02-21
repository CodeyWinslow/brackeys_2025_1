extends Node
class_name GameplayDirector

@export var spawn_player : bool = true
@export var player_prefab : PackedScene
@export var player_anchors : Array[Node3D]

@export var chaos_system : ChaosSystem
@export var incident_system : IncidentSystem
@export var ai_system : AiSystem

var player : Player
var round_timer : Timer

func _ready():
	_validate_properties()
	GameManager.register_gameplay_director(self)
	if spawn_player:
		_spawn_player()
	_start_countdown()
	
func _exit_tree():
	GameManager.unregister_gameplay_director(self)
	
func _validate_properties():
	if player_prefab == null:
		Logger.print_error('Player Prefab not set on GameplayDirector')
		
	if len(player_anchors) < 1:
		Logger.print_error('Must assign at least one player anchor to Gameplay Direction')

func _spawn_player():
	var position = player_anchors[0]
	player = player_prefab.instantiate() as Player
	if player != null:
		add_child(player)
		player.global_position = position.global_position
		player.global_rotation = position.global_rotation
	else:
		Logger.print_error('player prefab failed to instantiate (is it a Player script?)')
		
func get_player() -> Player:
	return player

func _start_countdown() -> void:
	if round_timer == null:
		round_timer = Timer.new()
		add_child(round_timer)
		round_timer.one_shot = true
	round_timer.start(30)

func get_time_left() -> float:
	if round_timer == null:
		Logger.print_error("Timer not started before attempting to get time left")
		return 0
	return round_timer.time_left
