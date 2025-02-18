extends RigidBody3D

@export var launch_force = 20.0

var stuck := false

func _ready():
	self.body_entered.connect(_on_body_entered)
	# Set initial physics properties
	gravity_scale = 1.0
	continuous_cd = true  # Enable continuous collision detection
	contact_monitor = true
	max_contacts_reported = 1

func fire_arrow():
	# Apply impulse in the given direction
	apply_central_impulse(global_transform.basis.z * launch_force)
	
func _on_body_entered(body):
	if stuck:
		return
		
	stuck = true  # Mark as stuck
	freeze = true  # Disable physics
	collision_layer = 0  # Disable further collisions
	collision_mask = 0
	
	# Attach arrow to the hit object (optional, prevents floating)
	reparent(body, true)
