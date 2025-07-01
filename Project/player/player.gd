extends CharacterBody3D
class_name Player3D

@onready var camera : Camera3D = %Camera3D
@onready var torch: Torch3D = %Torch
@onready var r_hand: Node3D = %RHand
@onready var l_hand: Node3D = %LHand

@onready var def_r_hand_pos : Vector3 = r_hand.position
@onready var def_l_hand_pos : Vector3 = l_hand.position

#region ExportVariables
@export_group("Movement")
@export var look_sensitivity : float = 0.006
@export var walk_speed : float = 6
@export var sprint_speed : float = 8
@export var acceleration : float = 14
@export var decceleration : float = 10
@export var ground_friction : float = 6.0

@export_group("CameraEffects")
## DEPRECATED VARIABLES
#@export var headbob_move_amount = 0.12
#@export var headbob_frequency = 1.2
@export var camera_rotation_amount : float = 0.04

@export_group("HandSwayEffects")
@export var hand_sway_amount : float = 2
@export var hand_rotation_amount : float = 0.1


#endregion

var wish_dir : Vector3 = Vector3.ZERO
var input_dir : Vector2
var headbob_time : float = 0.0
var time_since_last_footstep : float = 0.0

var can_take_input : bool = true
var mouse_input : Vector2

var last_used_door : Door3D = null

func _ready() -> void:
	GameManager.player_ref = self
	for child in $Body.find_children("*", "VisualInstance3D"):
		child.set_layer_mask_value(1, false)
		child.set_layer_mask_value(2, true) # world body 

func _unhandled_input(event: InputEvent) -> void:
	if !can_take_input: return
	
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			mouse_input = event.relative
			self.rotation.y += -mouse_input.x * look_sensitivity
			# self.rotation.y = lerp(self.rotation.y, self.rotation.y + -event.relative.x * look_sensitivity, .8)
			camera.rotation.x += (-mouse_input.y * look_sensitivity)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		
func _physics_process(delta: float) -> void:
	handle_input(delta)
	apply_gravity(delta)
	move_and_slide()
	
	
	call_effects(delta)


func handle_input(delta : float) -> void:
	if !can_take_input: return
	#region SourceMovement
	input_dir = Input.get_vector("move_left","move_right", "move_forward", "move_backward").normalized()
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


## DEPRECATED Function
#func headbob_effet(delta: float) -> void:
	#headbob_time += delta * self.velocity.length()
	#camera.transform.origin = Vector3(
		#cos(headbob_time * headbob_frequency * 0.5) * headbob_move_amount,
		#sin(headbob_time * headbob_frequency) * headbob_move_amount,
		#0
	#)




#region EFFECTS

func call_effects(delta : float) -> void:
	footsteps(delta)
	
	camera_tilt(delta)
	hand_tilt(l_hand, delta)
	hand_tilt(r_hand, delta)
	
	hand_sway(r_hand, delta)
	hand_sway(l_hand, delta)
	
	bob_effect(r_hand, def_r_hand_pos, delta)
	bob_effect(l_hand, def_l_hand_pos, delta)
	bob_effect(camera, Vector3(0,0,0), delta)
# Visuals
# -------------------------------------------------------------------------------------------------

func camera_tilt(delta : float) -> void:
	if camera:
		camera.rotation.z = lerp(camera.rotation.z, -input_dir.x * camera_rotation_amount, 10 * delta)

func hand_tilt(hand: Node3D, delta : float) -> void:
	if hand:
		hand.rotation.z = lerp(hand.rotation.z, -input_dir.x * hand_rotation_amount, 10 * delta)

func hand_sway(hand: Node3D, delta : float) -> void:
	mouse_input = lerp(mouse_input, Vector2.ZERO, 10 * delta)
	hand.rotation.x = lerp(hand.rotation.x, mouse_input.y * hand_rotation_amount, 10 * delta)
	hand.rotation.y = lerp(hand.rotation.y, mouse_input.x * hand_rotation_amount, 10 * delta)

## Takes a node and adds bob effect to it
func bob_effect(node : Node3D, def_node_pos : Vector3, delta : float,
 bob_amount : float = 0.05, bob_freq : float = 0.01
) -> void:
	if node:
		if velocity.length() > 0:
			node.position.y = lerp(node.position.y, def_node_pos.y + sin(Time.get_ticks_msec() * bob_freq) * bob_amount, 10 * delta)
			node.position.x = lerp(node.position.x, def_node_pos.x + sin(Time.get_ticks_msec() * bob_freq * 0.5) * bob_amount, 10 * delta)
			
		else:
			node.position.y = lerp(node.position.y, def_node_pos.y, 10 * delta)
			node.position.x = lerp(node.position.x, def_node_pos.x, 10 * delta)

# Sounds
# --------------------------------------------------------------------------------------------------
#TODO: Add footsteps
func footsteps(delta : float) -> void:
	if velocity.length() < 1: return
	time_since_last_footstep += delta * velocity.length() / 6
	
	if time_since_last_footstep * 10 > velocity.length():
		SFXManager.play_FX_3D(SFXManager.footsteps_sfx_array.pick_random(), self.global_position, 12, 1, 1)
		time_since_last_footstep = 0
#endregion
