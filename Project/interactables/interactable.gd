extends StaticBody3D
class_name Interactable3D


var is_focused : bool = false
var can_interact : bool = true


func _unhandled_input(event: InputEvent) -> void:
	if is_focused:
		if Input.is_action_just_pressed("interact"):
			print("Interacted with object: %s" % self)
			interact()

func on_ray_cast_collide(label_pos : Vector3) -> void:
	if !can_interact: 
		on_ray_cast_uncollide()
		return
	
	is_focused = true
	UIManager.show_crosshair()

func on_ray_cast_uncollide() -> void:
	is_focused = false
	UIManager.hide_crosshair()

func interact() -> void:
	pass
