extends Interactable3D
class_name InteractableToy

@export var toy_scene : PackedScene = load("res://toy/toy.tscn")

func interact():
	if can_interact == true:
		if !GameManager.player_ref: return
		
		
		var toy = toy_scene.instantiate()
		GameManager.player_ref.l_hand.add_child(toy)
		on_ray_cast_uncollide()
		get_parent().queue_free()
