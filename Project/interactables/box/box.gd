extends Interactable3D
class_name Box3D

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

var handle_open = false


func interact(body : CharacterBody3D):
	if can_interact:
		can_interact = false
		handle_open = !handle_open
		if handle_open == false:
			animation_player.play("close")
		if handle_open == true:
			animation_player.play("open")
		await animation_player.animation_finished
		can_interact = true
