extends Interactable3D
class_name Drawer3D

@onready var animation_player: AnimationPlayer = $"AnimationPlayer"
var drawer_open = false

func interact(body : CharacterBody3D):
	if can_interact:
		can_interact = false
		
		if drawer_open:
			animation_player.play("d_close")
		else:
			animation_player.play("d_open")
		
		drawer_open = !drawer_open
		await animation_player.animation_finished
		can_interact =true
