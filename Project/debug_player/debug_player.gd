extends CharacterBody3D
class_name DebugPlayer3D


var can_take_input : bool = false
@onready var camera : Camera3D = %Camera3D

func _ready() -> void:
	GameManager.debug_player_ref = self


func _unhandled_input(event: InputEvent) -> void:
	if !can_take_input: return
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			var mouse_input = event.relative
			self.rotation.y += -mouse_input.x * GameManager.player_ref.look_sensitivity
			# self.rotation.y = lerp(self.rotation.y, self.rotation.y + -event.relative.x * look_sensitivity, .8)
			camera.rotation.x += (-mouse_input.y * GameManager.player_ref.look_sensitivity)

func _physics_process(delta: float) -> void:
	handle_input(delta)

func handle_input(delta : float) -> void:
	if !can_take_input: return
	var input_dir := Input.get_vector("move_left","move_right", "move_forward", "move_backward").normalized()
	var wish_dir := self.global_transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)
	self.velocity = wish_dir * GameManager.player_ref.sprint_speed
	move_and_slide()
