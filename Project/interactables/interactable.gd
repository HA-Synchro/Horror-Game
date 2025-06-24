extends Area3D
class_name Interactable3D

@onready var label_3d: Label3D = $Label3D
var is_focused : bool = false

func _unhandled_input(event: InputEvent) -> void:
	if is_focused:
		if Input.is_action_just_pressed("interact"):
			print("Interacted with '%s'" % self)

func _on_body_entered(body: Node3D) -> void:
	if body is Player3D:
		is_focused = true
		label_3d.show()


func _on_body_exited(body: Node3D) -> void:
	if body is Player3D:
		is_focused = false
		label_3d.hide()
