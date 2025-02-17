extends Node3D

@export var bolt_scene: PackedScene 
@export var launch_power = 20.0

func _unhandled_input(event):
	if event.is_action_pressed("shoot"):  # Using the action we defined
		shoot()

func shoot():
	# Instance the bolt
	var bolt = bolt_scene.instantiate()
	
	# Add it to the scene
	get_tree().get_root().add_child(bolt)
	
	# Set position and rotation (assuming this script is on a Node3D)
	bolt.global_transform = global_transform
	
	# Launch in the forward direction
	bolt.launch(-global_transform.basis.z)
