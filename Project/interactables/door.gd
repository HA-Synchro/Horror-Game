extends Interactable3D
class_name Door3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var door_open : bool = false


func interact():
	if can_interact == true:
		can_interact = false
		
		door_open = !door_open
		
		if door_open == false:
			animation_player.play("close")
		if door_open == true:
			animation_player.play("open")
			
		await animation_player.animation_finished
		can_interact = true
