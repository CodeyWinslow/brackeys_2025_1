extends Node
class_name HUD

@export var chaos_meter : ProgressBar
@export var scope_overlay : Control
@export var bolt_config : BoltConfig
@export var bolt_image_texture : TextureRect

var chaos_system : ChaosSystem
var player : Player
var bolt_index : int = 0

func _ready():
	chaos_system = GameManager.game_director.chaos_system
	player = GameManager.game_director.get_player()
	_register_signals()
	_init_state()
	_set_bolt_info()

func _register_signals():
	chaos_system.chaos_changed.connect(_sig_chaos_changed)
	player.zoom_state_changed.connect(_sig_zoom_changed)

func _init_state():
	_set_chaos(chaos_system.get_chaos_amount())
	scope_overlay.visible = false # assume player is not zoomed initially

func _set_chaos(amount : int):
	var progress = amount*1.0 / chaos_system.get_chaos_threshold()
	chaos_meter.value = chaos_meter.max_value * progress

func _set_bolt_info():
	var bolt_info : BoltDefinition = bolt_config.bolts[bolt_index]
	bolt_image_texture.texture = bolt_info.hud_image

func _sig_chaos_changed(new_amount : int):
	_set_chaos(new_amount)

func _sig_zoom_changed(is_zoomed : bool):
	scope_overlay.visible = is_zoomed

func _sig_bolt_changed(new_bolt_index: int):
	bolt_index = new_bolt_index
	_set_bolt_info()
