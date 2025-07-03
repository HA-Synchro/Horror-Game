extends Interactable3D
class_name InteractableToy3D

signal toy_picked_up

@export var pickedup_toy_scene : PackedScene = load("res://enemies/toy/pickedup_toy.tscn")

func interact(body : CharacterBody3D):
	if can_interact == true:
		if !GameManager.player_ref: return
		
		toy_picked_up.emit()
		var toy = pickedup_toy_scene.instantiate()
		GameManager.player_ref.l_hand.add_child(toy)
		on_ray_cast_uncollide()
		get_parent().queue_free()
