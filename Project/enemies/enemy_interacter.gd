extends Area3D
class_name EnemyInteractArea3D

@onready var toy : Enemy3D = get_parent() as Enemy3D


func _process(delta: float) -> void:
	for body in get_overlapping_bodies():
		_on_body_entered(body)

func _on_body_entered(body: Node3D) -> void:
	if body is Player3D:
		if toy.does_have_knife:
			print("[%s] found player and killed him" % toy)
		else:
			print("[%s] found player" % toy)
			
	elif body is Door3D:
		if not body.door_open:
			body.interact(toy)
			print("[%s] Interacted with: %s" % [toy, body])
			
				
	elif body is InteractableKnife3D:
		body.interact(toy)
