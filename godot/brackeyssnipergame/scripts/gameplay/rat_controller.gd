extends StaticBody3D

@export var animationController: AnimationPlayer

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_P:
		playShameAnimation()

func playShameAnimation():
	animationController.play("Shame")
	
func playNodAnimation():
	animationController.play("Nod")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	animationController.play("rat_anim_lib/Talking")
