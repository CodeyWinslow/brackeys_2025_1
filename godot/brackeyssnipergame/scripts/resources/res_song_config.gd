extends Resource
class_name SongConfig

@export var name : String
@export var text : TextFileResource
@export var audio : AudioStream
@export var bpm : int = 120
@export var beats_per_note : int = 4
@export var first_note_beat_delay : int = 4
@export var note_speed : float = 50.0
