class_name CameraController

extends Node3D

@export var stageCameraPosition: Node3D
@export var ratCameraPosition: Node3D

@export var camera: Camera3D

func switch_to_stage_view():
	camera.reparent(stageCameraPosition)
	camera.transform = Transform3D()  # Resets position & rotation locally

func switch_to_rat_view():
	camera.reparent(ratCameraPosition)
	camera.transform = Transform3D()
