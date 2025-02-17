extends RigidBody3D

var launch_force = 20.0

func _ready():
	# Set initial physics properties
	gravity_scale = 1.0
	continuous_cd = true  # Enable continuous collision detection
	contact_monitor = true
	max_contacts_reported = 1

func launch_bolt(direction: Vector3):
	# Apply impulse in the given direction
	apply_central_impulse(direction * launch_force)
