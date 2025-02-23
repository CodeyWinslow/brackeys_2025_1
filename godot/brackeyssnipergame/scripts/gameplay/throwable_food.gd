extends Node3D

@export var rb : RigidBody3D
var time_alive : float = 0.0
const LIFETIME : float = 5.0 

func throw_food(player, throwPoint):
	var direction = (player.global_transform.origin - throwPoint.global_transform.origin).normalized()
	var force = direction * randf_range(5, 10)  # Adjust force magnitude as needed
	direction.x += randf_range(-0.2, 0.2)
	direction.y += randf_range(0.1, 0.5)  # Slight upward arc
	direction.z += randf_range(-0.2, 0.2)
	direction = direction.normalized()  # Normalize again after modification
	# Apply a random force
	var force_magnitude = randf_range(3, 7)  # Adjust range as needed
	rb.apply_central_impulse(direction * force_magnitude)

func _process(delta):
	time_alive += delta
	if time_alive >= LIFETIME:
		queue_free()
