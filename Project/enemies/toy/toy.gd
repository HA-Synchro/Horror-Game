extends Enemy3D
class_name ToyEnemy3D

var does_have_knife : bool = false

@export var knife_location: Node3D

@onready var knife : Node3D = get_tree().get_first_node_in_group("InteractableKnife")

func _process(delta: float) -> void:
	if current_target:
		$Target.text = current_target.name
	else: $Target.text = "null"
	
	if !nav.is_target_reachable():
		$Unreachable.text = "Unreachable"
	else:
		$Unreachable.text = ""


func _physics_process(delta: float) -> void:
	if !can_move: return
	
	move_on_nav_path(delta)

func move_on_nav_path(delta: float) -> void:
	
	if current_target == null:
		get_new_target()
		return
	
	nav.set_target_position(current_target.global_position)
	nav.get_next_path_position()
	
	if !nav.is_target_reachable():
		if current_target is Door3D: 
			get_new_target()
			return
			
		var closest_door : Door3D =  get_closest_door_to_target()
		if closest_door == null:
			return
		current_target = closest_door
	
	nav.set_target_position(current_target.global_position)
	nav.get_next_path_position()
	
	wish_dir = (nav.get_next_path_position() - global_transform.origin).normalized()
	velocity = wish_dir * speed
	move_and_slide()
	
	if wish_dir.length_squared() > 0:
		look_at(global_transform.origin + wish_dir, Vector3.UP)

func get_new_target():
	if current_target == null:
		print("[%s] -------------------------------------------------------------" % self)
		print("[%s] Getting new target...." % self)
		if !does_have_knife: current_target = knife
		else: current_target = GameManager.player_ref
		print("[%s] New Target is: %s" % [self, current_target])
	

	nav.set_target_position(current_target.global_position)
	nav.get_next_path_position()
