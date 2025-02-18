extends Node3D
class_name Player

@export var camera : Camera3D

var mouse_sensitivity = 0.15

signal zoom_state_changed(is_zoomed: bool)

var zoom_enabled = false
var target_fov : float = 60.0  # Default zoom level

# rotation limits (in degrees)
var min_pitch = -80
var max_pitch = 80
var min_yaw = -90
var max_yaw = 90

#zoom:
var zoom_speed : float = 5.0  # Speed of zoom
var min_fov : float = 30.0    # Minimum zoom (field of view)
var max_fov : float = target_fov    # Maximum zoom (field of view)

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
		
	if event.is_action_pressed("zoom_in"):
		if zoom_enabled:
			# Zoom in (decrease FOV)
			target_fov = max(target_fov - zoom_speed, min_fov)	
		
	if event.is_action_pressed("zoom_out"):
		if zoom_enabled:
			# Zoom out (increase FOV)
			target_fov = min(target_fov + zoom_speed, max_fov)
		
	# Smoothly transition FOV
	camera.fov = lerp(camera.fov, target_fov, 0.1)  # Smooth transition (adjust the lerp speed)
		
	if event.is_action_pressed("zoom"):
		print("Zoom pressed")
		zoom_enabled = true
		zoom_state_changed.emit(true)
		target_fov = max_fov - 10
		camera.fov = target_fov
	elif event.is_action_released("zoom"):
		zoom_enabled = false
		zoom_state_changed.emit(false)
		target_fov = max_fov
		camera.fov = target_fov
