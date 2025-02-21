extends CharacterBody3D
class_name NpcController

enum AIState
{
	Idle,
	Animating,
	Walking,
	Dying
}

@export var nav : NavigationAgent3D

const GRAVITY = 15.0

# context vars
var blackboard : Dictionary
var target_pos : Vector3
var isWalking : bool = false

# blackboard keys
var bb_idle_time = 'idle_time'

func _process(delta):
	pass
	
func _physics_process(delta):
	var force = Vector3.DOWN * delta
	
	
	if isWalking:
		nav.get_next_path_position()
	
func _pump_state(delta):
	pass
