extends CharacterBody3D
class_name Player3D


#region ExportVariables
@export_group("Movement")
@export var look_sensitivity : float = 0.006
@export var walk_speed : float = 7.0
@export var sprint_speed : float = 10
@export var acceleration : float = 14
@export var decceleration : float = 10
@export var ground_friction : float = 6.0

@export_group("CameraEffects")
@export var headbob_move_amount = 0.06
@export var headbob_frequency = 1.2

#endregion

var wish_dir : Vector3 = Vector3.ZERO
var headbob_time : float = 0.0
@onready var camera : Camera3D = %Camera3D

func _ready() -> void:
	for child in $Body.find_children("*", "VisualInstance3D"):
		child.set_layer_mask_value(1, false)
		child.set_layer_mask_value(2, true) # world body 

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * look_sensitivity)
			camera.rotate_x(-event.relative.y * look_sensitivity)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		
func _physics_process(delta: float) -> void:
	handle_input(delta)
	apply_gravity(delta)
	headbob_effet(delta)
	move_and_slide()

func handle_input(delta : float) -> void:
	#region SourceMovement
	var input_dir : Vector2 = Input.get_vector("move_left","move_right", "move_forward", "move_backward").normalized()
	wish_dir = self.global_transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)
	
	var cur_speed_in_wish_dir : float = self.velocity.dot(wish_dir)
	var add_speed_till_cap :float = get_move_speed() - cur_speed_in_wish_dir
	
	# acceleration
	if add_speed_till_cap > 0:
		var accel_speed = acceleration * delta * get_move_speed()
		accel_speed = min(accel_speed, add_speed_till_cap)
		self.velocity += accel_speed * wish_dir
	
	# friction
	var control : float = max(self.velocity.length(), decceleration)
	var drop : float = control * ground_friction * delta
	var new_speed : float = max(self.velocity.length() - drop, 0.0)
	if self.velocity.length() > 0:
		new_speed /= self.velocity.length()
	self.velocity *= new_speed
	#endregion
	
func get_move_speed() -> float:
	if Input.is_action_pressed("sprint"):
		return sprint_speed
	return walk_speed

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func headbob_effet(delta: float) -> void:
	headbob_time += delta * self.velocity.length()
	camera.transform.origin = Vector3(
		cos(headbob_time * headbob_frequency * 0.5) * headbob_move_amount,
		sin(headbob_time * headbob_frequency) * headbob_move_amount,
		0
	)
