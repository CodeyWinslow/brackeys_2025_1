extends Node3D

@export var castle_asset: Node3D
@export var rotation_speed: float = 0.4

#func _process(delta: float) -> void:
	#castle_asset.rotate_object_local(Vector3.UP, rotation_speed * delta)
