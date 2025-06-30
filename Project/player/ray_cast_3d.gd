extends RayCast3D

var hit_obj : Interactable3D = null


func _process(delta: float) -> void:
	if is_colliding():
		
		var hitObj = get_collider()
		
		## SHOBZ: THIS ISNT THE RIGHT WAY TO DO THIS
		# if we decide to use this method [your current method], we will have to create multiple interact functions for 
		# each object. What i am doing is that there is a class Interactable3D, which u can interact with
		# and every sub class like Door3D or LightSwitch etc etc, overrides the function interact() with 
		# their own code. Using this we only have to call interact() and depending upon the object it
		# will call that objects interact().
		# for example on calling door.interact() it opens up, while calling light_switch.interact() it turns on the light.
		
		#if hitObj.has_method("box_interact") && Input.is_action_just_pressed("interact"):
			#hitObj.box_interact()
		
		
		
		if  not (get_collider() is Interactable3D):
			if hit_obj:
				hit_obj.on_ray_cast_uncollide()
				hit_obj = null
			UIManager.hide_crosshair()
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
