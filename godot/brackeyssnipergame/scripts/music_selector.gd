extends Control

@export var songs : Array[SongConfig]
@export var music_selection_texture : Texture
@export var song_option_vbox : VBoxContainer
@export var text_theme : Theme

func _ready() -> void:
	for song in songs:
		var texture : TextureButton = _create_texture_button()
		var label : Label = _create_label(song)
		texture.add_child(label)
		song_option_vbox.add_child(texture)
		

func _create_texture_button() -> TextureButton:
	var texture : TextureButton = TextureButton.new()
	texture.texture_normal = music_selection_texture
	texture.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	texture.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	return texture

func _create_label(song: SongConfig) -> Label:
	var label : Label = Label.new()
	label.text = song.name
	label.theme = text_theme
	label.set_anchors_preset(Control.PRESET_CENTER)
	return label
