extends BaseButton


@export var hover_scale: float = 1.1
@export var click_sound: AudioStream

func _ready() -> void:
	connect("pressed", _on_pressed)
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)

func _on_mouse_entered() -> void:
	self.scale = Vector2(hover_scale, hover_scale)

func _on_mouse_exited() -> void:
	self.scale = Vector2(1.0, 1.0)

func _on_pressed() -> void:
	if click_sound:
		AudioManager.playSFX(click_sound)
