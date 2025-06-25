extends RayCast3D

var hit_obj : Interactable3D = null

func _process(delta: float) -> void:
	if is_colliding():
		if  not (get_collider() is Interactable3D): return
		
		# if alreay an object in focus
		if hit_obj:
			hit_obj.on_ray_cast_uncollide()
			hit_obj = null
			
		hit_obj = get_collider()
		hit_obj.on_ray_cast_collide((get_collision_point() + global_position) / 2)
	else:
		if hit_obj:
			hit_obj.on_ray_cast_uncollide()
			hit_obj = null
