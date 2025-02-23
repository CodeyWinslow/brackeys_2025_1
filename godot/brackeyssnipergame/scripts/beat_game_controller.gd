extends Node2D
class_name BeatGameController

enum LetterResultType
{
	Missed,
	Incorrect,
	Hit
}

class RecordedLetterResult:
	var letter : String
	var result : LetterResultType

signal note_hit
signal note_missed
signal note_incorrect
## Played some random note unprovoked
signal note_random

signal game_finished

@export var autostart : bool = true
@export var autostart_config : SongConfig

@export var letter_prefab : PackedScene
@export var audio_player : AudioStreamPlayer
@export var heartbeat_target : BeatTrigger
@export var text_preview : RichTextLabel

@export var letter_spawn_location : Node2D
@export var letter_trigger_location : Node2D
@export var letter_trigger_check_distance : float = 20.0
@export var heartbeat_apex_time : float = 0.2

# song specific configuration
var song : TextFileResource
var song_bpm : int = 120
var beats_per_note : int = 4
var first_note_beat_delay : int = 4
var note_speed : float = 50.0

var config : SongConfig
var song_words : Array[String]
var is_spawning : bool = true

var spawn_word_index : int = 0
var spawn_letter_index : int = 0
var current_word : String = ""
var current_letter : String = ""

var time_between_beats : float = 60.0 / song_bpm

var time_elapsed : float = 0
var letter_travel_time : float = 0

var latest_heartbeat_lookahead : int = -1
var latest_beat_lookahead : int = -1 # used to spawn letters ahead so they meet target on beat

var spawned_letters : Array[LetterController]
var recorded_results : Array[RecordedLetterResult]

var results_per_word : Array

func _ready():
	if autostart and autostart_config:
		init(autostart_config)
		start_game()
	
func _input(event):
	if event is InputEventKey:
		var key = event as InputEventKey
		if _is_valid_key(key.keycode) and key.pressed and not key.echo:
			_on_letter_pressed(key)
	
func _process(_delta):
	# determine elapsed time in song + delta
	var prev_time = time_elapsed
	time_elapsed = audio_player.get_playback_position()
	var delta = time_elapsed - prev_time
	
	# move spawned letters
	for letter in spawned_letters:
		var next_pos = letter.global_position + Vector2.LEFT * delta * note_speed
		letter.global_position = next_pos
	
	# clean up any missed notes
	var missed_letters = []
	for letter in spawned_letters:
		if _did_miss_note(letter):
			missed_letters.append(letter)
	
	for letter in missed_letters:
		_consume_letter(letter, LetterResultType.Missed)
	
	# play beat visual
	var heartbeat_time = time_elapsed + heartbeat_apex_time
	var heartbeat_beat = floor(heartbeat_time / time_between_beats)
	if heartbeat_beat > latest_heartbeat_lookahead:
		latest_heartbeat_lookahead = heartbeat_beat
		var time_into_beat = heartbeat_time - (heartbeat_beat * time_between_beats)
		_play_heartbeat(time_into_beat)
	
	# determine note spawning beat
	var lookahead_time = time_elapsed + letter_travel_time
	if lookahead_time > 0:
		var future_beat : int = floor(lookahead_time / time_between_beats)
		if future_beat > latest_beat_lookahead:
			latest_beat_lookahead = future_beat
			if future_beat > first_note_beat_delay \
				and (future_beat - first_note_beat_delay) % beats_per_note == 0:
				
				var time_into_beat = lookahead_time - (future_beat * time_between_beats)
				
				if not _are_all_notes_spawned():
					var new_letter = _spawn_next_letter(time_into_beat)
					spawned_letters.append(new_letter)
					_increment_letter()

func init(song_config : SongConfig):
	config = song_config
	_parse_config()
	
	song_words = []
	song_words.append_array(song.get_text().strip_escapes().split(' ', false))
	results_per_word = []
	for word in song_words:
		results_per_word.append([])
	
	spawn_word_index = 0
	spawn_letter_index = 0
	latest_heartbeat_lookahead = -1
	latest_beat_lookahead = -1
	current_word = ''
	current_letter = ''
	letter_travel_time = abs(letter_spawn_location.global_position.x - letter_trigger_location.global_position.x) / note_speed
	assert(letter_travel_time < first_note_beat_delay * time_between_beats) # we will miss our first letter if our first beat is too early
	
	_cache_spawn_vars()
	_update_text_preview()

func start_game():
	visible = true
	audio_player.play()

func _parse_config():
	song = config.text
	song_bpm = config.bpm
	beats_per_note = config.beats_per_note
	first_note_beat_delay = config.first_note_beat_delay
	note_speed = config.note_speed
	audio_player.stream = config.audio

func _is_valid_key(key : Key):
	return (key >= KEY_A and key <= KEY_Z) \
		or key == KEY_COMMA \
		or key == KEY_PERIOD

func _are_all_notes_spawned(): 
	return spawn_word_index >= len(song_words)

func _increment_letter():
	spawn_letter_index += 1
	if spawn_letter_index >= len(current_word):
		spawn_letter_index = 0
		spawn_word_index += 1
		
	_cache_spawn_vars()
		
func _on_letter_pressed(input_key : InputEventKey):
	var input_letter : String = ''
	
	if input_key.keycode >= KEY_A and input_key.keycode <= KEY_Z:
		input_letter = input_key.as_text_key_label()
	elif input_key.keycode == KEY_COMMA:
		input_letter = ','
	elif input_key.keycode == KEY_PERIOD:
		input_letter = '.'
	
	if input_letter.is_empty():
		return
	
	heartbeat_target.trigger()
	
	if spawned_letters.is_empty():
		note_random.emit()
		return
	
	var next_letter : LetterController = spawned_letters.front() as LetterController
	if next_letter:
		var target_letter = next_letter.get_letter().to_upper()
		if abs(letter_trigger_location.global_position.x - next_letter.global_position.x) <= letter_trigger_check_distance:
			if input_letter == target_letter:
				_consume_letter(next_letter, LetterResultType.Hit)

			else:
				_consume_letter(next_letter, LetterResultType.Incorrect)
		else:
			note_random.emit()
		
func _did_miss_note(letter : LetterController):
	return letter.global_position.x < letter_trigger_location.global_position.x \
		and letter_trigger_location.global_position.x - letter.global_position.x > letter_trigger_check_distance
		
func _consume_letter(letter : LetterController, result : LetterResultType):
	var letter_result : RecordedLetterResult = RecordedLetterResult.new()
	letter_result.letter = letter.get_letter()
	letter_result.result = result
	
	var word_index = letter.get_context() as int
	results_per_word[word_index].append(letter_result)
	
	spawned_letters.erase(letter)
	
	match result:
		LetterResultType.Hit:
			letter.notify_hit()
			note_hit.emit()
		LetterResultType.Missed:
			letter.notify_missed()
			note_missed.emit()
		LetterResultType.Incorrect:
			letter.notify_wrong_note()
			note_incorrect.emit()
			
	_update_text_preview()
	
	if spawned_letters.is_empty():
		game_finished.emit()
		
func _cache_spawn_vars():
	current_word = ''
	if spawn_word_index < len(song_words):
		current_word = song_words[spawn_word_index]
		
	current_letter = ''
	if spawn_letter_index < len(current_word):
		current_letter = current_word[spawn_letter_index]
		
func _spawn_next_letter(time_spent : float):
	var spawn_location = letter_spawn_location.global_position
	var instance : LetterController = letter_prefab.instantiate() as LetterController
	if instance:
		add_child(instance)
		instance.global_position = spawn_location + Vector2.LEFT * note_speed * time_spent
		instance.set_info(current_letter, spawn_word_index)
		
	return instance

func _update_text_preview():
	var output : String = "[center]"
	
	for wi in range(len(song_words)):
		for li in range(len(results_per_word[wi])):
			var result = results_per_word[wi][li] as RecordedLetterResult
			match result.result:
				LetterResultType.Hit:
					output += '[color=#112f8c]%s[/color]' % result.letter
				_:
					output += '[color=#732c2c]%s[/color]' % result.letter
		if len(results_per_word[wi]) < len(song_words[wi]):
			output += song_words[wi].substr(len(results_per_word[wi]))
		output += ' '
	
	output += '[/center]'
	text_preview.text = output
	
func _play_heartbeat(time : float):
	heartbeat_target.heartbeat(time)
