extends RayCast3D

var hit_obj : Interactable3D = null


func _process(delta: float) -> void:
	if is_colliding():
		
		var hitObj = get_collider()
		
		if hitObj.has_method("box_interact") && Input.is_action_just_pressed("interact"):
			hitObj.box_interact()
		
		
		
		if  not (get_collider() is Interactable3D):
			if hit_obj:
				hit_obj.on_ray_cast_uncollide()
				hit_obj = null
			return
		
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
