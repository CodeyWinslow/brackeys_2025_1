extends Node3D

class_name Player

@export var arrow: PackedScene 
@export var launch_power = 20.0
@export var reload_time = 1.0

var can_shoot = true
@export var cooldown_timer : Timer  # Reference to a Timer node

func _ready():
	cooldown_timer.timeout.connect(_on_cooldown_finished)

func _unhandled_input(event):
	if event.is_action_pressed("shoot"):  # Using the action we defined
		shoot()

func shoot():
	if (!can_shoot):
		return
		
	# Instance the arrow
	var arrowInstance = arrow.instantiate()
	# Add it to the scene
	get_tree().get_root().add_child(arrowInstance)
	
	# Set position and rotation
	arrowInstance.global_transform = global_transform
	
	arrowInstance.fire_arrow()
	
	# Start cooldown
	can_shoot = false
	cooldown_timer.start(reload_time)

func _on_cooldown_finished():
	can_shoot = true
