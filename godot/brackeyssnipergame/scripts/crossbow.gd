extends Node3D

@export var arrow: PackedScene 
@export var launch_power = 20.0

func _unhandled_input(event):
	if event.is_action_pressed("shoot"):  # Using the action we defined
		shoot()

func shoot():
	# Instance the arrow
	var arrowInstance = arrow.instantiate()
	# Add it to the scene
	get_tree().get_root().add_child(arrowInstance)
	
	# Set position and rotation
	arrowInstance.global_transform = global_transform
	
	arrowInstance.fire_arrow()
