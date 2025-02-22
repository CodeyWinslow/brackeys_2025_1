extends Node3D

@export var anim : AnimationPlayer
@export var player : Node3D
@export var throwPoint : Node3D

@export var throwableFoods: Array[PackedScene]

var is_idling = false
const IDLE_TIME = 2
var elapsed_time = 0

# animation constants
const ANIM_IDLE = 'Idle'
const ANIM_WALK = 'Hop'

func _ready() -> void:
	play_anim_hop()
	
func _process(delta):
	if (is_idling):
		elapsed_time += delta
		if (elapsed_time > IDLE_TIME):
			play_anim_hop()
			is_idling = false
			elapsed_time = 0
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		throw_random_food_at_player()
	
func throw_random_food_at_player():
	if throwableFoods.is_empty() or not player or not throwPoint:
		print("Error, no foods to throw or no player/throw point.")
		return
		
	play_anim_idle()
	
	is_idling = true
		
	var random_food_prefab = throwableFoods[randi() % throwableFoods.size()]
	var food_instance = random_food_prefab.instantiate()
	
	add_child(food_instance)
	
	food_instance.global_transform = throwPoint.global_transform
	
	food_instance.throw_food(player, throwPoint)
	
func play_anim_idle():
	anim.play(ANIM_IDLE)
	var anim_time = randf_range(0, anim.get_animation(ANIM_IDLE).length)
	anim.seek(anim_time)
	
func play_anim_hop():
	anim.play(ANIM_WALK)
	var anim_time = randf_range(0, anim.get_animation(ANIM_WALK).length)
	anim.seek(anim_time)
