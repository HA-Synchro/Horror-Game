extends RayCast3D

var hit_obj = null


@onready var toy : Enemy3D = get_parent() as Enemy3D

func _process(_delta: float) -> void:
	if !toy.can_move: return
	if is_colliding():
		hit_obj = get_collider()
		
		if hit_obj is Player3D:
			print("found player")
			
		if hit_obj is Door3D:
			if hit_obj.door_open: pass #get_parent()._pick_new_wander_point()
			else: hit_obj.interact()
		
