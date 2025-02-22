extends Node

@export var food_throwing_npcs: Node3D

@export var stageCameraPosition: Node3D
@export var ratCameraPosition: Node3D

var beatErrors = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func beat_error():
	beatErrors += 1
	throw_food()
	
func throw_food():
	for npc in food_throwing_npcs.get_children():
		if npc.has_method("throw_food"):
			npc.throw_food()
