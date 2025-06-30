extends RayCast3D

var hitObj = null

func _process(delta: float) -> void:
	if is_colliding():
		hitObj = get_collider()
		if hitObj.has_method("get_move_speed"):
			print("PLayer detected")
		if hitObj.has_method("interact"):
			hitObj.interact()
		
