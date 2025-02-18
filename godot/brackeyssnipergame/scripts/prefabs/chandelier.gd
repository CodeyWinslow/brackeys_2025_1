extends RigidBody3D

signal chandelier_destroyed

var _top_level_group = "Indirect Kill"
var _low_level_group = "Chandelier"

var aoeIndicator : MeshInstance3D
var aoeMesh : CylinderMesh

var spawnedCircle : bool = false

var rateOfAoeChange : float = 1.0
var aoeCap : float = 3.0

var spawn_delay_timer : Timer
var spawn_timer_length : float = 0.5

var destroy_timer : Timer
var destroy_timer_length : float = 4

var flash_timer : Timer
var flash_timer_length = 0.25
var isFlashing = false

func _spawn_circle() -> void: 
	if !spawnedCircle:
		Logger.print("Spawning circle...")
		
		var space_state = get_world_3d().direct_space_state
		
		var query = PhysicsRayQueryParameters3D.create(position, position + Vector3(0, -10, 0))
		query.exclude = [self]
		
		var result = space_state.intersect_ray(query)
		
		#if result:
		aoeIndicator.global_position = result.position
		#else:
			#aoeIndicator.position = position + Vector3(0, -.25, 0)
		
		spawnedCircle = true
		destroy_timer.start(destroy_timer_length)
		aoeIndicator.visible = true

func _is_settled() -> bool:
	var result = false
	if abs(linear_velocity.x) < 0.001 && abs(linear_velocity.z) < 0.001 && abs(linear_velocity.y) < 0.001:
		result = true
	return result

func _handle_circle(delta: float) -> void:
	if spawnedCircle:
		if aoeMesh.top_radius <= aoeCap:
			aoeMesh.top_radius += rateOfAoeChange * delta
	
		if destroy_timer.time_left < 2.0 && !isFlashing:
			isFlashing = true
			flash_timer.start(flash_timer_length)

func _handle_flash_timeout() -> void: 
	if aoeIndicator.visible:
		aoeIndicator.visible = false
	else:
		aoeIndicator.visible = true

func _destroy_timer_timeout() -> Vector3:
	emit_signal("chandelier_destroyed")
	queue_free()
	return position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Logger.print("_ready: Initializing %s's..." % _top_level_group)
	
	add_to_group(_top_level_group)
	Logger.print("[%s] _ready: Added %s to the group." % 
		[_top_level_group, _top_level_group])
	
	add_to_group(_low_level_group)
	Logger.print("[%s] [%s] _ready: Added %s to the group." % 
		[_top_level_group, _low_level_group, _low_level_group])
	
	aoeIndicator = $AreaOfEffect
	
	aoeMesh = aoeIndicator.mesh.duplicate()
	aoeIndicator.mesh = aoeMesh
	
	spawn_delay_timer = Timer.new()
	spawn_delay_timer.one_shot = true
	
	destroy_timer = spawn_delay_timer.duplicate()
	destroy_timer.timeout.connect(_destroy_timer_timeout)
	
	flash_timer = Timer.new()
	flash_timer.timeout.connect(_handle_flash_timeout)
	
	add_child(spawn_delay_timer)
	add_child(destroy_timer)
	add_child(flash_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _is_settled() && !freeze && spawn_delay_timer.time_left == 0:
		_spawn_circle()
	
	_handle_circle(delta)

func _on_area_detection_area_entered(area: Area3D) -> void:
	if freeze:
		freeze = false
		spawn_delay_timer.start(spawn_timer_length)
