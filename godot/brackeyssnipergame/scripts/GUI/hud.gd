extends Node
class_name HUD

@export var chaos_meter : ProgressBar
@export var test_string : Label

var chaos_system : ChaosSystem
var player : Node3D

func _ready():
	chaos_system = GameManager.game_director.chaos_system
	player = GameManager.game_director.get_player()
	_register_signals()
	_init_state()

func _register_signals():
	chaos_system.chaos_changed.connect(_sig_chaos_changed)

func _init_state():
	_set_chaos(chaos_system.get_chaos_amount())

func _set_chaos(amount : int):
	var progress = amount*1.0 / chaos_system.get_chaos_threshold()
	chaos_meter.value = chaos_meter.max_value * progress

func _sig_chaos_changed(new_amount : int):
	_set_chaos(new_amount)
