extends StaticBody3D

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

var door_open = false
var can_interact = true

func interact():
	if can_interact == true:
		can_interact = false
		door_open = !door_open
		if door_open == false:
			animation_player.play("close")
		if door_open == true:
			animation_player.play("open")
		await get_tree().create_timer(1.0, false).timeout
		can_interact = true
