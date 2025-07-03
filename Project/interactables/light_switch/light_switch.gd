extends Interactable3D
class_name LightSwitch3D

@onready var animation_player: AnimationPlayer = $"AnimationPlayer"
var light_on = false

func _ready() -> void:
	if light_on: $OmniLight3D.show()
	else: $OmniLight3D.hide()

func interact(body : CharacterBody3D):
	if can_interact:
		can_interact = false
		
		if light_on:
			animation_player.play("light_off")
			$OmniLight3D.hide()
		else:
			animation_player.play("light_on")
			$OmniLight3D.show()
			
		light_on = !light_on
		await animation_player.animation_finished
		can_interact =true
