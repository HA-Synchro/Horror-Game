extends Area3D
class_name EnemyInteractArea3D



@onready var toy : Enemy3D = get_parent() as Enemy3D

func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if body is Player3D:
		if toy.does_have_knife:
			print("[TOY] found player and killed him")
		else:
			print("[TOY] found player")
			
	elif body is Door3D:
		if not body.door_open:
			body.interact(toy)
			print("[TOY] Interacted with: ",toy.current_target)
			if toy.current_target == body:
				toy.current_target = null
				
	elif body is InteractableKnife3D:
		body.interact(toy)
