extends Node3D

func launch(direction: Vector3):
	get_node("RigidBody3D").launch_bolt(direction)
