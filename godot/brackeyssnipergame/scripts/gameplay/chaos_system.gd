extends Node
class_name ChaosSystem

signal chaos_changed(chaos_amount:int)
signal chaos_threshold_reached

@export var config : ChaosConfig

var chaos_value = 0
var decay_delta = 0

func _ready():
	if config == null:
		Logger.print_error('No config set for ChaosSystem!')
	
	assert(config != null)
	chaos_value = config.initial_chaos

func _enter_tree():
	_register_commands()
	
func _exit_tree():
	_unregister_commands()

func _process(delta):
	_process_decay(delta)
	
func _process_decay(delta):
	decay_delta += delta
	while decay_delta > config.decay_time:
		if chaos_value > 0:
			decay_delta = max(0, decay_delta - config.decay_time)
			_apply_chaos_decay()
		else:
			decay_delta = 0
		
func _apply_chaos_decay():
	var prev_chaos = chaos_value
	chaos_value = max(0, chaos_value - config.decay_amount)
	if prev_chaos != chaos_value:
		chaos_changed.emit(chaos_value)

func get_chaos_amount() -> int:
	return chaos_value
	
func get_chaos_threshold() -> int:
	return config.chaos_threshold

func add_chaos(amount : float):
	var prev_value = chaos_value
	chaos_value = min(config.chaos_threshold, chaos_value + amount)
	chaos_value = max(0, chaos_value)
	if prev_value != chaos_value:
		chaos_changed.emit(chaos_value)
		if chaos_value >= config.chaos_threshold:
			chaos_threshold_reached.emit()
		decay_delta = 0

# Commands

func _register_commands():
	Console.add_command('game.chaos.setmax', _cmd_max_chaos)

func _unregister_commands():
	Console.remove_command('game.chaos.setmax')

func _cmd_max_chaos():
	add_chaos(get_chaos_threshold() - get_chaos_amount())
