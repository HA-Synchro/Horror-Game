extends Interactable3D
class_name Drawer3D

@onready var animation_player: AnimationPlayer = $"AnimationPlayer"
var drawer_open = false

func interact():
	if can_interact:
		can_interact = false
		drawer_open = !drawer_open
		if drawer_open == false:
			animation_player.play("d_close")
		if drawer_open == true:
			animation_player.play("d_open")
		await animation_player.animation_finished
		can_interact =true
