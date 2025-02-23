extends Sprite2D
class_name BeatTrigger

@export var anim : AnimationPlayer
@export var shake_time : float = 1.0
@export var shake_angle : float = 90.0

var shake_playing_time : float
var shake_target_rotation : float

func _ready():
	shake_playing_time = INF

func heartbeat(time_into_heartbeat : float):
	anim.play('heartbeat_anim')
	anim.seek(time_into_heartbeat)
	
func trigger():
	shake_target_rotation = randf_range(-shake_angle, shake_angle)
	shake_playing_time = 0
	_evaluate_and_apply_shake()

func _process(delta):
	if shake_playing_time < shake_time:
		shake_playing_time = min(shake_playing_time + delta, shake_time)
		_evaluate_and_apply_shake()
	
func _evaluate_and_apply_shake():
	var alpha = shake_playing_time / shake_time
	alpha = sin(alpha * PI)
	var angle = alpha * shake_target_rotation
	rotation_degrees = angle
