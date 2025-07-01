extends RayCast3D



var hit_obj = null

func _process(delta: float) -> void:
	if is_colliding():
		hit_obj = get_collider()
		
		if hit_obj is Player3D:
			print("found player")
			
		if hit_obj is Door3D:
			if hit_obj.door_open: get_parent()._pick_new_wander_point()
			else: hit_obj.interact()
		
