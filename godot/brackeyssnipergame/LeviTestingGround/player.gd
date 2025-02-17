extends Node3D

@onready var camera = $Camera3D

var mouse_sensitivity = 0.3

# rotation limits (in degrees)
var min_pitch = -80
var max_pitch = 80
@export var min_yaw = -90
@export var max_yaw = 90

# Track current yaw for clamping
var current_yaw = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event) -> void:
	if event is InputEventMouseMotion:
		# Calculate new yaw
		var new_yaw = current_yaw + (-event.relative.x * mouse_sensitivity)
		# Clamp the horizontal rotation
		new_yaw = clamp(new_yaw, min_yaw, max_yaw)
		# Calculate the actual rotation to apply
		var yaw_change = new_yaw - current_yaw
		rotate_y(deg_to_rad(yaw_change))
		current_yaw = new_yaw
		
		# Rotate camera up/down (pitch)
		var current_rotation = camera.rotation_degrees.x
		var new_rotation = current_rotation + (-event.relative.y * mouse_sensitivity)
		# Clamp the vertical rotation
		new_rotation = clamp(new_rotation, min_pitch, max_pitch)
		camera.rotation_degrees.x = new_rotation
		
	# Press ESC to free the mouse
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
