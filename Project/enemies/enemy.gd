extends CharacterBody3D
class_name Enemy3D

@onready var nav : NavigationAgent3D = $NavigationAgent3D

@export var speed            : float = 2.5     
@export var chase_range      : float = 24.0
@export var wander_radius    : float = 6.0     
@export var wadner_cooldown  : float = 2.0     
 

var current_target : Node3D:
	set(value):
		current_target = value
		if current_target == null:
			return
		elif current_target is Door3D:
			nav.set_target_position(current_target.mesh_instance_3d.global_position)
		else:
			nav.set_target_position(current_target.global_position)
		nav.get_next_path_position() # calls update for nav


		
var target_last_position : Vector3
var wander_time   : float = 0.0              
var can_move : bool = true

func _ready() -> void:
	randomize()                 
	add_to_group("Enemies")     
	pick_new_wander_point()
	GameManager.nav_region.bake_finished.connect(on_rebake_nav_mesh)

func _physics_process(delta: float) -> void:
	if !can_move: return
	
	if GameManager.player_ref:
		get_new_target_position(delta)

	var next_pos := nav.get_next_path_position()
	var dir      := (next_pos - global_transform.origin).normalized()
	velocity     = dir * speed
	move_and_slide()
	
	if dir.length_squared() > 0:
		look_at(global_transform.origin + dir, Vector3.UP)

func get_new_target_position(delta: float):
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
		target_last_position= GameManager.player_ref.global_position
		var to_player := target_last_position - global_transform.origin
		if to_player.length_squared() <= chase_range * chase_range:
			nav.set_target_position(target_last_position)
			wander_time = 0.0
		else:
			wander_time -= delta
			if wander_time <= 0.0 or nav.is_navigation_finished():
				pick_new_wander_point()
				wander_time = wadner_cooldown

func pick_new_wander_point() -> void:
	var random_dir := Vector3(
		randf_range(-1.0, 1.0),
		0.0,
		randf_range(-1.0, 1.0)
	).normalized()

	var candidate := global_transform.origin + random_dir * wander_radius

	var nav_map: RID = nav.get_navigation_map()
	if nav_map.is_valid():
		candidate = NavigationServer3D.map_get_closest_point(nav_map, candidate)

	nav.set_target_position(candidate)

func get_closest_door_to_target() -> Door3D:
	
	var closest_door : Door3D
	if nav.get_current_navigation_path() == PackedVector3Array(): return null
	
	nav.set_target_position(current_target.global_position) 
	nav.get_next_path_position()
	await nav.path_changed
	
	var last_reachable_position : Vector3 = current_target.global_position
	

	for door in get_tree().get_nodes_in_group("Doors") as Array[Door3D]:
		# set first door to be closest
		if !closest_door:
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

func on_rebake_nav_mesh() -> void:
	current_target = null
