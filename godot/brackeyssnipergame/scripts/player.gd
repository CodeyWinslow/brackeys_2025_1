extends Node3D

@export var camera : Camera3D

var mouse_sensitivity = 0.15

# rotation limits (in degrees)
var min_pitch = -80
var max_pitch = 80
var min_yaw = -90
var max_yaw = 90

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event) -> void:
	if event is InputEventMouseMotion:
		#Rotate camera left/right (yaw)
		var current_yaw_rotation = camera.rotation_degrees.y
		var new_yaw_rotation = current_yaw_rotation + (-event.relative.x * mouse_sensitivity)
		#clamp horizontal
		new_yaw_rotation = clamp(new_yaw_rotation, min_yaw, max_yaw)
		camera.rotation_degrees.y = new_yaw_rotation
		
		#Rotate camera up/down (pitch)
		var current_pitch_rotation = camera.rotation_degrees.x
		var new_pitch_rotation = current_pitch_rotation + (-event.relative.y * mouse_sensitivity)
		#Clamp vertical
		new_pitch_rotation = clamp(new_pitch_rotation, min_pitch, max_pitch)
		camera.rotation_degrees.x = new_pitch_rotation
		
	# Press ESC to free the mouse
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
