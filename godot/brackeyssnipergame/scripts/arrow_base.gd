extends RigidBody3D

var launch_force = 200.0
var current_time = 0
var lifetime = 100 #seconds
@export var smoke_emitter : CPUParticles3D

var stuck := false

func _ready():
	self.body_entered.connect(_on_body_entered)
	# Set initial physics properties
	gravity_scale = 1.0
	continuous_cd = true  # Enable continuous collision detection
	contact_monitor = true
	max_contacts_reported = 1

func _process(delta: float) -> void:
	if stuck:
		current_time += delta
		if current_time > lifetime:
			queue_free()

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
	call_deferred("_stick_to_body", body)

func _stick_to_body(body):
	reparent(body, true)  # Reparent safely after physics processing
	smoke_emitter.emitting = false;
