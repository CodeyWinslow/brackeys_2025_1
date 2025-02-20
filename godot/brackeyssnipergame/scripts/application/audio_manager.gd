extends Node

var masterVolume: float = 1.0

@export var sfxPlayer: AudioStreamPlayer
@export var musicPlayer: AudioStreamPlayer

@export var music: Array[AudioStream] = []

var musicTrack: int = 0

func audioManagerDoSomething():
	print("you called the audio manager.")
	
func playSFX(sfx: AudioStream):
	sfxPlayer.stream = sfx
	sfxPlayer.play()
	
func _play_random_music_track():
	var randomSelectedTrack = randi_range(0, music.size() - 1)
	print("random selected track: " + randomSelectedTrack)
	musicPlayer.stream = music[randomSelectedTrack]
	musicPlayer.play()
	
func _play_next_music_track():
	musicTrack += 1
	if musicTrack > music.size() - 1:
		musicTrack = 0
	musicPlayer.stream = music[musicTrack]
	musicPlayer.play()
	
func _on_scene_changed():
	print("playing first music track")
	musicPlayer.stream = music[musicTrack]
	musicPlayer.play()
	#_play_random_music_track()

func _on_music_player_finished() -> void:
	print("playing next music track")
	_play_next_music_track()
