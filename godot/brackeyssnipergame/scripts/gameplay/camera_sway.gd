extends Camera3D

@export var sway_speed: float = 2.0   # Speed of the sway
@export var sway_amount: float = 0.015  # Maximum sway angle

var time_passed: float = 0.0

func _process(delta: float) -> void:
	time_passed += delta
	var sway_angle = sin(time_passed * sway_speed) * sway_amount
	rotation.y = sway_angle  # Apply sway to the Z-axis (rolling motion)
