extends Node
class_name GameplayDirector

@export var player_prefab : PackedScene
@export var player_anchors : Array[Node3D]

@export var chaos_system : ChaosSystem
@export var incident_system : IncidentSystem

var player : Player

func _ready():
	_validate_properties()
	GameManager.register_gameplay_director(self)
	_spawn_player()
	
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
	else:
		Logger.print_error('player prefab failed to instantiate (is it a Player script?)')
		
func get_player() -> Player:
	return player
