extends Node
class_name MusicDirector

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _exit_tree() -> void:
	GameManager.unregister_music_director(self)
