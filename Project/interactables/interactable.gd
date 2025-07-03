extends StaticBody3D
class_name Interactable3D


var is_focused : bool = false
var can_interact : bool = true



func _unhandled_input(_event: InputEvent) -> void:
	if is_focused:
		if Input.is_action_just_pressed("interact"):
			interact(GameManager.player_ref)

func on_ray_cast_collide() -> void:
	if !can_interact: 
		on_ray_cast_uncollide()
		return
	
	is_focused = true
	UIManager.show_crosshair()

func on_ray_cast_uncollide() -> void:
	is_focused = false
	UIManager.hide_crosshair()

func interact(body : CharacterBody3D) -> void:
	pass
