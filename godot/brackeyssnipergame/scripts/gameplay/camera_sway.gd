extends Camera3D

@export var sway_speed: float = 2.0   # Speed of the sway
@export var sway_amount_x: float = 0.015  # Maximum sway angle for X-axis (pitch)
@export var sway_amount_y: float = 0.015  # Maximum sway angle for Y-axis (yaw)
@export var sway_amount_z: float = 0.015  # Maximum sway angle for Z-axis (roll)

var time_passed: float = 0.0
var base_rotation: Vector3

func _ready() -> void:
	# Store the initial rotation
	base_rotation = rotation

func _process(delta: float) -> void:
	time_passed += delta
	var sway_angle = sin(time_passed * sway_speed)
	
	# Apply sway on top of the base rotation
	rotation.x = base_rotation.x + (sway_angle * sway_amount_x)  # Pitch
	rotation.y = base_rotation.y + (sway_angle * sway_amount_y)  # Yaw
	rotation.z = base_rotation.z + (sway_angle * sway_amount_z)  # Roll
