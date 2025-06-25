extends StaticBody3D
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

var drawer_open = false
var can_interact = true

func drawer_interact():
	if can_interact:
		can_interact = false
		drawer_open = !drawer_open
		if drawer_open == false:
			animation_player.play("d_close")
		if drawer_open == true:
			animation_player.play("d_open")
		await get_tree().create_timer(.5, false).timeout
		can_interact =true
