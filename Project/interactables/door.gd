extends Interactable3D
class_name Door3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var door_open : bool = false
var door_open_Ai : bool = false
var player_int : bool
var ai_int : bool = false
func interact():
	if can_interact == true:
		can_interact = false
		
		
		
		if door_open:
			animation_player.play("close")
			player_int = true
		else:
			animation_player.play("open")
			player_int = false
		
		door_open = !door_open
		
		await animation_player.animation_finished
		can_interact = true

func AI_door_Interact():
	if door_open == false:
		if can_interact:
			can_interact = false
			animation_player.play("open")
			await animation_player.animation_finished
			door_open = true
			can_interact = true
			
		
