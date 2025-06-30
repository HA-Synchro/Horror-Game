extends Interactable3D

func interact():
	if can_interact == true:
		if !GameManager.player_ref: return
		
		var child : Node3D = GameManager.player_ref.l_hand.get_child(0)
		var toy = child.toy_scene.instantiate()
		$"../Toy".add_child(toy)
		child.queue_free()
