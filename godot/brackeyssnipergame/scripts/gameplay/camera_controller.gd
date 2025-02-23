class_name CameraController

extends Node3D

@export var stageCameraPosition: Node3D
@export var ratCameraPosition: Node3D

@export var ratToStagePath: PathFollow3D
@export var stageToRatPath: PathFollow3D

@export var animationController: AnimationPlayer

@export var camera: Camera3D

func switch_to_stage_view():
	camera.reparent(ratToStagePath)
	animationController.play("animate_camera_to_stage")

func switch_to_rat_view():
	camera.reparent(stageToRatPath)
	animationController.play("animate_camera_to_rat")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	print("animation completed: " + anim_name)
	if anim_name == "animate_camera_to_stage":
		print("here")
		camera.reparent(stageCameraPosition)
		camera.transform = Transform3D()
	if anim_name == "animate_camera_to_rat":
		camera.reparent(ratCameraPosition)
		camera.transform = Transform3D()
