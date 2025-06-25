extends Interactable3D
class_name Door3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var door_open : bool = false


func interact():
	if can_interact == true:
		can_interact = false
		
		
		
		if door_open:
			animation_player.play("close")
		else:
			animation_player.play("open")
		
		door_open = !door_open
		await animation_player.animation_finished
		can_interact = true
