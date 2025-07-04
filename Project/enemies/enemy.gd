extends CharacterBody3D
class_name Enemy3D

@onready var nav : NavigationAgent3D = $NavigationAgent3D

@export var speed : float = 2.5     

var current_target : Node3D
	#set(value):
		#current_target = value
		#if current_target == null:
			#return
		#elif current_target is Door3D:
			#nav.set_target_position(current_target.mesh_instance_3d.global_position)
		#else:
			#nav.set_target_position(current_target.global_position)
		#nav.get_next_path_position() # calls update for nav

var target_last_position : Vector3           
var wish_dir : Vector3
var can_move : bool = true

func _ready() -> void:         
	add_to_group("Enemies")     
	#GameManager.nav_region.bake_finished.connect(on_rebake_nav_mesh)
	#nav.target_reached.connect(on_target_reached)
	get_new_target()

func _physics_process(delta: float) -> void:
	if !can_move: return
	
	move_on_nav_path(delta)

func move_on_nav_path(delta: float) -> void:
	
	wish_dir = (nav.get_next_path_position() - global_transform.origin).normalized()
	velocity = wish_dir * speed
	move_and_slide()
	
	if wish_dir.length_squared() > 0:
		look_at(global_transform.origin + wish_dir, Vector3.UP)
		
func get_new_target():
	if !nav.is_target_reachable():
		if current_target is Door3D: return
		
		var closest_door := await get_closest_door_to_target()
		nav.set_target_position(closest_door.global_position)
		# GETS LAST DOOR
		#if !GameManager.player_ref.last_used_door: return
		#nav.set_target_position(GameManager.player_ref.last_used_door.mesh_instance_3d.global_position)
		#GameManager.player_ref.last_used_door = null
		#
		# Gets last player position
		# nav.set_target_position(target_last_position)
	else:
		target_last_position = GameManager.player_ref.global_position
		var to_player := target_last_position - global_transform.origin

func get_closest_door_to_target() -> Door3D:
	
	var closest_door : Door3D = null
	# if nav.get_current_navigation_path() == PackedVector3Array(): return null
	
	var last_reachable_position : Vector3 = nav.get_final_position()
	print("[%s] Last Reachable Position is: %s" % [self, last_reachable_position])

	for door in get_tree().get_nodes_in_group("Doors") as Array[Door3D]:
		# set first door to be closest
		if closest_door == null:
			if door.door_open:
				continue
			closest_door = door
			continue
		
		# gets closer door
		if last_reachable_position.distance_squared_to(door.global_position) <= last_reachable_position.distance_squared_to(closest_door.global_position):
			if door.door_open:
				continue
			closest_door = door
		
	return closest_door

#func on_rebake_nav_mesh() -> void:
	#current_target = null

#func on_target_reached() -> void:
	#print("Target Reached")
	## get_new_target()
