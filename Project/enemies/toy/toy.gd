extends Enemy3D
class_name ToyEnemy3D

var does_have_knife : bool = false

@export var knife_location: Node3D

@onready var knife : Node3D = get_tree().get_first_node_in_group("InteractableKnife")

func get_new_target_position(delta: float):
	if current_target == null:
		if !does_have_knife: current_target = knife
		else: current_target = GameManager.player_ref
		
		return
	
	if !nav.is_target_reachable():
		if current_target is Door3D: return
		var closest_door : Door3D = await get_closest_door_to_target()
		if closest_door == null:
			return
		
		current_target = closest_door
	else:
		target_last_position = current_target.global_position
		nav.set_target_position(target_last_position)
		nav.get_next_path_position()
		wander_time = 0.0
		
