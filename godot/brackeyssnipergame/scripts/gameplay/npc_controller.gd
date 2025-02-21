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
@export var anim : AnimationPlayer

const GRAVITY = 15.0

var state : AIState = AIState.Idle

# context vars
var blackboard : Dictionary
var target_pos : Vector3
var isWalking : bool = false
var finishedWalking : bool = false

# blackboard keys
const bb_idle_time = 'idle_time'

# animation constants
const ANIM_IDLE = 'Idle'
const ANIM_WALK = 'Hop'

func _ready():
	nav.navigation_finished.connect(_on_reached_destination)
	_on_enter_state()

func _process(delta):
	pass
	
func _physics_process(delta):
	var force = Vector3.DOWN * delta
	
	if isWalking and not finishedWalking:
		nav.get_next_path_position()
	
func _pump_state(delta):
	pass

func _on_enter_state():
	match state:
		AIState.Idle:
			anim.play(ANIM_IDLE)
		AIState.Walking:
			isWalking = true
			anim.play(ANIM_WALK)

func _on_exit_state():
	match state:
		AIState.Walking:
			isWalking = false

func _on_reached_destination():
	finishedWalking = true
