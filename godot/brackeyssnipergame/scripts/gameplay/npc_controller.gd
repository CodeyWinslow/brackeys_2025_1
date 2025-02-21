extends CharacterBody3D
class_name NpcController

enum AIState
{
	Idle,
	LookAround,
	Walking,
	Panic,
	Dying
}

@export var nav : NavigationAgent3D
@export var nav_agent_radius : float
@export var anim : AnimationPlayer
@export var walk_speed : float = 0.5

@export var debug_points : Array[Node3D]
var debug_index = 0

const GRAVITY = 15.0

var state : AIState = AIState.Walking

# context vars
var blackboard : Dictionary
var target_pos : Vector3
var isWalking : bool = false
var finishedWalking : bool = false
var is_panicking : bool = false

# blackboard keys
const bb_idle_time = 'idle_time'

# animation constants
const ANIM_IDLE = 'Idle'
const ANIM_WALK = 'Hop'

func _ready():
	var gdir = GameManager.get_gameplay_director()
	if gdir:
		var aisys = gdir.ai_system
		aisys.register_npc(self)
	
	nav.navigation_finished.connect(_on_reached_destination)
	# DEBUG
	if len(debug_points) > 0:
		debug_index = randi() % len(debug_points)
		nav.target_position = debug_points[debug_index].global_position
		
	_on_enter_state()

func _process(delta):
	pass
	
func _physics_process(delta):
	if isWalking and not finishedWalking:
		var target = nav.get_next_path_position()
		target += Vector3.DOWN * nav_agent_radius # fix nav points
		var move = target - global_position
		if move.length_squared() > 0.01:
			velocity = move.normalized() * walk_speed
			move_and_slide()
			if not target.is_equal_approx(global_position):
				look_at(target, Vector3.UP)

func notify_panic(should_panic):
	is_panicking = should_panic
	if is_panicking:
		print("i'm panicking")

func _pump_state(delta):
	pass

func _play_anim_random(anim_name):
	anim.play(anim_name)
	var anim_time = randf_range(0, anim.get_animation(anim_name).length)
	anim.seek(anim_time)

func _on_enter_state():
	match state:
		AIState.Idle:
			_play_anim_random(ANIM_IDLE)
		AIState.Walking:
			isWalking = true
			_play_anim_random(ANIM_WALK)

func _on_exit_state():
	match state:
		AIState.Walking:
			isWalking = false

func _on_reached_destination():
	if false:
		finishedWalking = true
	
	if len(debug_points) > 0:
		debug_index = randi() % len(debug_points)
		nav.target_position = debug_points[debug_index].global_position
