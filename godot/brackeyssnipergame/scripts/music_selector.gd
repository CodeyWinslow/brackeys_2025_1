extends Control

@export var songs : Array[SongConfig]
@export var music_selection_texture : Texture
@export var selected_song_texture : Texture
@export var song_option_vbox : VBoxContainer
@export var text_theme : Theme
@export var button_script : Script
@export var audio_player : AudioStreamPlayer

var button_to_song_map = {}

func _ready() -> void:
	for song in songs:
		var control : Control = Control.new()
		var texture : TextureButton = _create_texture_button()
		var label : CenterContainer = _create_label(song)
		control.add_child(texture)
		control.size_flags_horizontal = SIZE_SHRINK_CENTER
		control.size_flags_vertical = SIZE_SHRINK_CENTER
		control.custom_minimum_size = Vector2(256, 88)
		texture.add_child(label)
		texture.set_script(button_script)
		song_option_vbox.add_child(control)
		button_to_song_map[texture] = song

func _create_texture_button() -> TextureButton:
	var texture : TextureButton = TextureButton.new()
	texture.texture_normal = music_selection_texture
	texture.texture_focused = selected_song_texture
	texture.size_flags_horizontal = SIZE_SHRINK_CENTER
	texture.size_flags_vertical = SIZE_SHRINK_CENTER
	texture.pivot_offset = Vector2(128, 44)
	texture.pressed.connect(_sample_song.bind(texture))
	return texture

func _create_label(song: SongConfig) -> CenterContainer:
	var label: Label = Label.new()
	label.text = song.name
	label.theme = text_theme
	var centered_label = CenterContainer.new()
	centered_label.add_child(label)
	centered_label.set_anchors_preset(PRESET_FULL_RECT)
	return centered_label

func _sample_song(button: TextureButton) -> void:
	audio_player.stop()
	var songConfig : SongConfig = button_to_song_map[button]
	audio_player.stream = songConfig.audio
	audio_player.play()
	audio_player.seek(20)
