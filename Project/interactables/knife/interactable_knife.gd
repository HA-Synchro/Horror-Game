extends Interactable3D
class_name InteractableKnife3D


@export var knife_model : Node3D

func interact(body : CharacterBody3D):
	if can_interact == true:
		
		if body == GameManager.player_ref:
			print("[Player] I better not use this thing.")
			return
		
		if body is ToyEnemy3D:
			body.knife_location.add_child(knife_model)
			body.does_have_knife = true
		
		on_ray_cast_uncollide()
		get_parent().queue_free()
