extends Node

var masterVolume: float = 1.0

@export var sfxPlayer: AudioStreamPlayer
@export var musicPlayer: AudioStreamPlayer

@export var music: Array[AudioStream] = []

var musicTrack: int = 0
	
func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	
	# save me from self kill
	if GameManager.is_editor:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(0))
	
func _on_music_player_finished() -> void:
	play_next_music_track()
	
func playSFX(sfx: AudioStream):
	sfxPlayer.stream = sfx
	sfxPlayer.play()
	
func play_random_music_track():
	var randomSelectedTrack = randi_range(0, music.size() - 1)
	musicPlayer.stream = music[randomSelectedTrack]
	musicPlayer.play()
	
func play_next_music_track():
	musicTrack += 1
	if musicTrack > music.size() - 1:
		musicTrack = 0
	musicPlayer.stream = music[musicTrack]
	musicPlayer.play()
